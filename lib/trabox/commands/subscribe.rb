require_relative './subscribe/argument_parser'
require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        ArgumentParser.parse!

        raise unless config.valid?

        subscriber = Trabox::PubSub::Subscriber.new config.subscription_id

        subscriber.listen(&config.listen_callback)
      end
    end
  end
end
