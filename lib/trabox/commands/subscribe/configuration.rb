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
