require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        config_activate

        require_relative './runner'
        require_relative './logger'

        raise unless config.valid?

        subscriber = config.subscriber

        subscriber.subscribe
      end
    end
  end
end
