require 'trabox/pubsub/provider/google'

module Trabox
  module PubSub
    class Subscriber
      def initialize(subscription_id, opts = {})
        @subscriber = Provider::Google::Subscriber.new subscription_id, opts
      end

      def listen(opts = {}, error_callbacks: [], &callback)
        @subscriber.listen opts, error_callbacks: error_callbacks, &callback
      end
    end
  end
end
