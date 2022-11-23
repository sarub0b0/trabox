module Trabox
  module Command
    module Subscribe
      class << self
        attr_accessor :active
        alias active? active

        def configure
          return unless active?

          yield config
        end

        def config
          @config ||= Configuration.new
        end

        def config_activate
          @active = true
        end
      end

      class Configuration
        # @!attribute [rw] subscriber
        #   @return [Option::Relayer]
        attr_accessor :subscriber

        def valid?
          @subscriber.is_a?(Trabox::Subscriber)
        end
      end
    end
  end
end
