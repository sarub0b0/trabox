require 'rails_helper'
require 'support/pubsub'

RSpec.describe Trabox::Publisher::Google::Cloud::PubSub do
  pubsub_topic_id = ENV['PUBSUB_EMULATOR_TOPIC_ID'] || ENV['PUBSUB_TOPIC_ID']
  pubsub_subscription_id = ENV['PUBSUB_EMULATOR_SUBSCRIPTION_ID'] || ENV['PUBSUB_SUBSCRIPTION_ID']

  describe '.initialize' do
    before do
      @pubsub = PubSub.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
      @pubsub.setup
    end

    describe ':topic_id' do
      it '１文字以上の文字列が設定されていること' do
        expect { described_class.new pubsub_topic_id }.not_to raise_error
      end

      it 'blankのときエラーを返す' do
        @pubsub.clear
        expect { described_class.new '' }.to raise_error(StandardError)
        expect { described_class.new nil }.to raise_error(StandardError)
      end
    end
  end

  describe '#publish' do
    let(:publisher) do
      double_topic = double(Google::Cloud::PubSub::Topic)

      allow(double_topic).to receive(:enable_message_ordering!)
      allow(double_topic).to receive_message_chain(:publish, :message_id) { '1' }
      allow(double_topic).to receive_message_chain(:publish, :ordering_key) { nil }

      allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic) { double_topic }

      described_class.new pubsub_topic_id
    end

    before do
      @pubsub = PubSub.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
      @pubsub.setup
    end

    describe 'argument/message' do
      it '一文字以上の文字列であるとき' do
        event = create(:relayer_test)
        expect { publisher.publish event }.not_to raise_error
      end

      it 'blankのとき' do
        expect { publisher.publish nil }.to raise_error(StandardError)
        expect { publisher.publish '' }.to raise_error(StandardError)
      end
    end

    describe 'one shot' do
      before do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id
        )

        @pubsub.setup
      end

      context 'publishに成功したとき' do
        it 'message_idを返す' do
          publisher = described_class.new pubsub_topic_id
          message_id = publisher.publish create(:relayer_test)

          expect(message_id).to be_truthy
        end
      end

      context 'publishに失敗したとき' do
        it 'エラーを返す' do
          allow_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:publish).and_raise('error')

          publisher = described_class.new pubsub_topic_id

          expect { publisher.publish create(:relayer_test) }.to(raise_error('error'))
        end
      end
    end

    describe 'enable message ordering' do
      before do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id
        )

        @pubsub.setup
      end

      subject do
        10.times.each { |idx| publisher.publish create(:relayer_test, event_data: idx.to_s) }
      end

      let(:publisher) do
        described_class.new pubsub_topic_id, message_ordering: true,
                                             ordering_key: Trabox::Publisher::Google::Cloud::PubSub::OrderingKey.new('test')
      end

      it 'publishした順番通りにsubscribeできる' do
        subject

        received_message_ids = @pubsub.subscription.pull(immediate: false).map(&:message_id).map(&:to_i)

        sorted_received_message_ids = received_message_ids.sort

        expect(received_message_ids).to eq(sorted_received_message_ids)
      end
    end
  end
end

RSpec.describe Trabox::Publisher::Google::Cloud::PubSub::OrderingKey do
  describe '.initialize' do
    subject { described_class.new key }

    context 'Procを設定したとき' do
      let(:key) { ->(arg) { "#{arg}" } }

      it { expect { subject }.not_to raise_error }
    end

    context 'Stringを設定したとき' do
      let(:key) { 'test' }

      it { expect { subject }.not_to raise_error }
    end

    context 'Stringでない値を設定したとき' do
      it 'ArgumentErrorを返す' do
        expect { described_class.new 0 }.to raise_error(ArgumentError)
        expect { described_class.new true }.to raise_error(ArgumentError)
        expect { described_class.new Object.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#call' do
    subject { described_class.new key }
    context '文字列を返すProcを設定したとき' do
      let(:key) { ->(a, b) { "proc-#{a}-#{b}" } }

      it '文字列を返す' do
        expect(subject.call('A', 'B')).to eq('proc-A-B')
      end
    end

    context 'Stringを設定したとき' do
      let(:key) { 'test' }
      it '文字列を返す' do
        expect(subject.call).to eq('test')
      end

      it '引数を与えてもエラーにならない' do
        expect(subject.call(1, 2, 3)).to eq('test')
      end
    end

    context '文字列を返さないProcを設定したとき' do
      let(:key) { ->(a, b) { a + b } }

      it 'エラーを返す' do
        expect { subject.call(1, 2) }.to raise_error(RuntimeError)
      end
    end
  end
end
