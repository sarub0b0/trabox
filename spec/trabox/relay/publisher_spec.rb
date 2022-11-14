require 'rails_helper'
require 'support/pubsub'

describe Trabox::Relay::Publisher do
  pubsub_topic_id = ENV['PUBSUB_EMULATOR_TOPIC_ID'] || ENV['PUBSUB_TOPIC_ID']
  pubsub_subscription_id = ENV['PUBSUB_EMULATOR_SUBSCRIPTION_ID'] || ENV['PUBSUB_SUBSCRIPTION_ID']

  describe '.initialize' do
    before do
      @pubsub = PubSub.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
      @pubsub.setup
    end

    describe ':topic_id' do
      it '１文字以上の文字列が設定されていること' do
        expect { described_class.new topic_id: pubsub_topic_id }.not_to raise_error
      end

      it 'nilのときエラーを返す' do
        expect { described_class.new topic_id: nil }.to raise_error(ArgumentError)
      end

      it 'blankのときエラーを返す' do
        @pubsub.clear
        expect { described_class.new topic_id: pubsub_topic_id }.to raise_error(StandardError)
      end
    end
  end

  describe '#publish' do
    let(:publisher) do
      double_topic = double(Google::Cloud::PubSub::Topic)

      allow(double_topic).to receive(:enable_message_ordering!)
      allow(double_topic).to receive_message_chain(:publish, :message_id) { '1' }

      allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic) { double_topic }

      described_class.new topic_id: pubsub_topic_id
    end

    before do
      @pubsub = PubSub.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
      @pubsub.setup
    end

    describe 'argument/message' do
      subject { publisher.publish message: message, ordering_key: 'key' }

      context 'nilのとき' do
        let(:message) { nil }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '\'\'のとき' do
        let(:message) { '' }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context '一文字以上の文字列であるとき' do
        let(:message) { '{ "a": 1 }' }

        it { expect { subject }.not_to raise_error }
      end
    end

    describe 'one shot' do
      before do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      context 'publishに成功したとき' do
        it 'message_idを返す' do
          publisher = described_class.new topic_id: pubsub_topic_id
          message_id = publisher.publish message: '{}', ordering_key: 'key'

          expect(message_id).to be_truthy
        end
      end

      context 'publishに失敗したとき' do
        it 'エラーを返す' do
          allow_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:publish).and_raise('error')

          publisher = described_class.new topic_id: pubsub_topic_id

          expect { publisher.publish message: '{}', ordering_key: 'key' }.to(raise_error('error'))
        end
      end
    end

    describe 'enable message ordering' do
      before do
        @pubsub = PubSub.new(
          topic_id: pubsub_topic_id,
          subscription_id: pubsub_subscription_id,
        )

        @pubsub.setup
      end

      subject { 10.times.each { |idx| publisher.publish message: idx.to_s, ordering_key: 'trabox' } }

      let(:publisher) { described_class.new topic_id: pubsub_topic_id, enable_message_ordering: true }

      it 'publishした順番通りにsubscribeできる' do
        subject

        received_message_ids = @pubsub.subscription.pull(immediate: false).map(&:message_id)

        sorted_received_message_ids = received_message_ids.sort

        expect(received_message_ids).to eq(sorted_received_message_ids)
      end
    end
  end
end
