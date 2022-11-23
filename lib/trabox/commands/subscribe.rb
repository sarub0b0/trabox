require_relative './subscribe/argument_parser'
require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        ArgumentParser.parse!

        raise unless config.valid?

        subscriber = config.subscriber

        subscriber.subscribe
      end
    end
  end
end
