require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        raise unless config.valid?

        subscriber = config.subscriber

        subscriber.subscribe
      end
    end
  end
end
