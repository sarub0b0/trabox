require 'google/cloud/pubsub'

# Google::Cloud::PubSub::Topicのラッパー
module Trabox
  module Relay
    class Publisher
      # @param topic_id [String]
      # @param ordering_key [Boolean]
      def initialize(topic_id: nil, enable_message_ordering: false)
        raise ArgumentError, 'topic_id must be specified.' if topic_id.blank?

        @pubsub = Google::Cloud::PubSub.new

        @topic = @pubsub.topic topic_id

        raise "Topic '#{topic_id}' does not exist." if @topic.nil?

        @topic.enable_message_ordering! if enable_message_ordering
      end

      # @param message [String] JSONエンコードされた文字列
      # @param ordering_key [String]
      # @return message_id [String]
      def publish(message: nil, ordering_key: nil)
        raise ArgumentError if message.blank?

        published_message = @topic.publish message, ordering_key: ordering_key

        Rails.logger.debug 'JSON-encoded message published. ' \
          "message_id=#{published_message.message_id} ordering_key=#{ordering_key}"

        published_message.message_id
      end
    end
  end
end
