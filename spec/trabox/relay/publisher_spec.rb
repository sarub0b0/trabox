require 'rails_helper'
require 'support/pubsub_cleaner'

describe Trabox::Relay::Publisher do
  pubsub_topic_id = ENV['PUBSUB_EMULATOR_TOPIC_ID'] || ENV['PUBSUB_TOPIC_ID']
  pubsub_subscription_id = ENV['PUBSUB_EMULATOR_SUBSCRIPTION_ID'] || ENV['PUBSUB_SUBSCRIPTION_ID']

  describe '.initialize' do
    before do
      @pubsub_cleaner = PubSubCleaner.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
      @pubsub_cleaner.setup
    end

    it 'topic_idが設定されていること' do
      expect { described_class.new pubsub_topic_id }.not_to raise_error
    end

    it 'nilのときエラーを返す' do
      expect { described_class.new nil }.to raise_error(ArgumentError)
    end

    it 'topicが存在しないときエラーを返す' do
      @pubsub_cleaner.clear
      expect { described_class.new pubsub_topic_id }.to raise_error(StandardError)
    end
  end

  describe '#publish' do
    context 'arguments' do
      let(:publisher) do
        double_topic = double(Google::Cloud::PubSub::Topic)

        allow(double_topic).to receive(:enable_message_ordering!)
        allow(double_topic).to receive_message_chain(:publish, :message_id) { '1' }

        allow_any_instance_of(Google::Cloud::PubSub::Project).to receive(:topic) { double_topic }

        described_class.new pubsub_topic_id
      end

      before do
        @pubsub_cleaner = PubSubCleaner.new(topic_id: pubsub_topic_id, subscription_id: pubsub_subscription_id)
        @pubsub_cleaner.setup
      end

      context 'message' do
        subject { publisher.publish message: message, ordering_key: 'key' }

        context 'messageがnilのとき' do
          let(:message) { nil }

          it { expect { subject }.to raise_error(ArgumentError) }
        end

        context 'messageが\'\'のとき' do
          let(:message) { '' }

          it { expect { subject }.to raise_error(ArgumentError) }
        end

        context 'messageが一文字以上の文字列であるとき' do
          let(:message) { '{ "a": 1 }' }

          it { expect { subject }.not_to raise_error }
        end
      end

      context 'ordering_key' do
        subject { publisher.publish message: '{}', ordering_key: ordering_key }

        context 'ordering_keyがnilのとき' do
          let(:ordering_key) { nil }

          it { expect { subject }.to raise_error(ArgumentError) }
        end

        context 'ordering_keyが\'\'のとき' do
          let(:ordering_key) { '' }

          it { expect { subject }.to raise_error(ArgumentError) }
        end

        context 'ordering_keyが一文字以上の文字列のとき' do
          let(:ordering_key) { 'key' }

          it { expect { subject }.not_to raise_error }
        end
      end

      describe 'publish' do
        before(:context) do
          @pubsub_cleaner = PubSubCleaner.new(
            topic_id: pubsub_topic_id,
            subscription_id: pubsub_subscription_id,
          )

          @pubsub_cleaner.setup
        end

        context 'publishに成功したとき' do
          it 'message_idを返す' do
            publisher = described_class.new pubsub_topic_id
            message_id = publisher.publish message: '{}', ordering_key: 'key'

            expect(message_id).to be_truthy
          end
        end

        context 'publishに失敗したとき' do
          it 'エラーを返す' do
            allow_any_instance_of(Google::Cloud::PubSub::Topic).to receive(:publish).and_raise('error')

            publisher = described_class.new pubsub_topic_id

            expect { publisher.publish message: '{}', ordering_key: 'key' }.to(raise_error('error'))
          end
        end
      end
    end
  end
end
