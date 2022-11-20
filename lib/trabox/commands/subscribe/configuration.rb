require_relative './option'

module Trabox
  module Command
    module Subscribe
      class << self
        def configure
          yield config
        end

        def config
          @config ||= Configuration.new
        end

        def subscriber_config
          config.subscriber
        end
      end

      class Configuration
        # @!attribute [rw] subscriber
        #   @return [Option::Relayer]
        attr_accessor :subscriber

        def initialize
          @subscriber = Option::Subscriber.new
        end

        def valid?
          @subscriber.valid?
        end
      end
    end
  end
end
