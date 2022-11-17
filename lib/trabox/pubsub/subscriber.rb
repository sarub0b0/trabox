require 'trabox/pubsub/provider/google'

module Trabox
  module PubSub
    class Subscriber
      def initialize(subscription_id, opts = {})
        @subscriber = Provider::Google::Subscriber.new subscription_id, opts
      end

      def listen(opts = {}, &callback)
        @subscriber.listen opts, &callback
      end
    end
  end
end
