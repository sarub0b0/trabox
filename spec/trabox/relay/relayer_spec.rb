require 'rails_helper'
require 'support/pubsub'
require 'support/model_setup'

pubsub_topic_id = ENV['PUBSUB_EMULATOR_TOPIC_ID'] || ENV['PUBSUB_TOPIC_ID']
pubsub_subscription_id = ENV['PUBSUB_EMULATOR_SUBSCRIPTION_ID'] || ENV['PUBSUB_SUBSCRIPTION_ID']

RSpec.describe Trabox::Relay::Relayer do
  describe '.initialize' do
    context 'publisher' do
      subject { described_class.new publisher }

      context 'nilのとき' do
        let(:publisher) { nil }
        it { expect { subject }.to raise_error(TypeError) }
      end

      context 'topicが設定されているとき' do
        let(:publisher) do
          publisher = double(Trabox::PubSub::Publisher)
          allow(publisher).to receive(:instance_of?).and_return(true)
          publisher
        end
        it { expect { subject }.not_to raise_error }
      end
    end
  end

  describe '#relay' do
    subject do
      publisher = Trabox::PubSub::Publisher.new pubsub_topic_id
      relay = described_class.new publisher
      relay.relay
    end

    context 'イベントレコードがあるとき' do
      before(:context) do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      before do
        @published_event = create(:relayer_test)
      end

      it 'イベントデータをpublishしてsubscribeできる状態にする' do
        subject

        messages = @pubsub.subscription.pull(immediate: false)

        expect(messages).to be_truthy
      end

      it 'publishされたイベントデータのmessage_idとpublished_atを更新する' do
        subject

        expect do
          @published_event.reload
        end.to(
          change(@published_event, :published_at).and(change(@published_event, :message_id)),
        )
      end
    end

    context 'イベントレコードがないとき' do
      before(:context) do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      before do
        @published_event = create(:relayer_test)
        @published_event.update!(message_id: '1', published_at: Time.current.to_formatted_s(:iso8601))
      end

      it 'publishしない' do
        allow_any_instance_of(Trabox::PubSub::Publisher).to receive(:instance_of?).and_return(true)
        allow_any_instance_of(Trabox::PubSub::Publisher).to receive(:publish)

        subject

        expect_any_instance_of(Trabox::PubSub::Publisher).not_to receive(:publish)
      end

      it 'message_idとpublished_atを更新しない' do
        allow_any_instance_of(Trabox::Relay::Relayable).to receive(:published_done!)

        subject

        expect_any_instance_of(Trabox::Relay::Relayable).not_to receive(:published_done!)
        expect { @published_event.reload }.not_to change { @published_event }
      end
    end

    context 'エラーのとき' do
      before(:context) do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      before do
        @published_events = create_list(:relayer_test, 10)
      end

      subject do
        publisher = Trabox::PubSub::Publisher.new pubsub_topic_id
        relay = described_class.new publisher, limit: 10
        relay.relay
      end

      context 'Publisher#publishがエラーのとき' do
        it 'エラーを返す' do
          allow_any_instance_of(Trabox::PubSub::Publisher).to receive(:instance_of?).and_return(true)
          allow_any_instance_of(Trabox::PubSub::Publisher).to receive(:publish).and_raise('error')

          expect { subject }.to raise_error('error')
        end

        it 'ロールバックする' do
          allow_any_instance_of(Trabox::PubSub::Publisher).to receive(:instance_of?).and_return(true)

          publish_count = 0
          allow_any_instance_of(Trabox::PubSub::Publisher).to(
            receive(:publish).and_wrap_original do |m, *args|
              raise 'error' if publish_count >= 3

              publish_count += 1
              m.call(*args)
            end,
          )

          expect { subject }.to raise_error('error')

          @published_events.map!(&:reload)

          expect(@published_events.map(&:published_at)).to all(be_nil)
        end
      end

      context 'PublishedEvent#published_done!がエラーのとき' do
        before(:context) do
          @pubsub = PubSub.new(
            topic_id: pubsub_topic_id,
            subscription_id: pubsub_subscription_id,
          )

          @pubsub.setup
        end

        it 'エラーを返す' do
          allow_any_instance_of(Trabox::Relay::Relayable).to receive(:published_done!).and_raise('error')

          expect { subject }.to raise_error('error')
        end

        it 'ロールバックする' do
          publish_count = 0
          allow_any_instance_of(Trabox::Relay::Relayable).to(
            receive(:published_done!).and_wrap_original do |m, *args|
              raise 'error' if publish_count >= 3

              publish_count += 1
              m.call(*args)
            end,
          )

          expect { subject }.to raise_error('error')

          @published_events.map!(&:reload)

          expect(@published_events.map(&:published_at)).to all(be_nil)
        end
      end
    end

    context '複数プロセスのとき', use_truncation: true do
      before(:context) do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      let(:event_amount) { 50 }
      let(:limit) { 10 }
      let(:thread_amount) { 5 }

      before do
        @published_events = create_list(:relayer_test, event_amount)
        threads = Array.new(thread_amount) do
          Thread.new do
            ActiveRecord::Base.connection_pool.with_connection do
              publisher = Trabox::PubSub::Publisher.new pubsub_topic_id
              relay = described_class.new publisher, limit: limit
              relay.relay
            end
          end
        end

        threads.each(&:join)
      end

      it '重複なしのメッセージをpublishする' do
        messages = @pubsub.subscription.pull(immediate: false)

        decoded = messages.map { |m| m.data.to_i }

        expect(decoded.uniq.length).to eq(event_amount)
      end
    end
  end
end
