require_relative './subscribe/argument_parser'
require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        ArgumentParser.parse!

        raise unless config.valid?

        subscriber = Trabox::PubSub::Subscriber.new subscriber_config.subscription_id

        subscriber.listen(
          {},
          error_callbacks: subscriber_config.error_callbacks,
          &subscriber_config.listen_callback
        )
      end
    end
  end
end
