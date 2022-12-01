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

        def check
          return if @subscriber.respond_to?(:subscribe)

          raise 'Subscribe Configuration: config.subscriber must be have :subscribe method.'
        end
      end
    end
  end
end
