require 'trabox/pubsub/provider/google'

module Trabox
  module PubSub
    class Publisher
      # @param topic_id [String]
      # @param opts [Hash] provider options
      def initialize(topic_id, opts = {})
        @publisher = Trabox::PubSub::Provier::Google::Publisher.new(
          topic_id,
          opts,
        )
      end

      # @param message [String] publishするメッセージ
      # @param opts [Hash] provider options
      def publish(message, opts = {})
        @publisher.publish message, opts
      end
    end
  end
end
