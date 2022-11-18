module Trabox
  module Command
    module Subscribe
      def self.perform
        subscription_id = ENV.fetch('PUBSUB_SUBSCRIPTION_ID')

        subscriber = Trabox::PubSub::Subscriber.new subscription_id

        raise "'#{subscription_id}' does not exist." if subscriber.nil?

        subscriber.listen(&config.listen_callback)
      end
    end
  end
end
