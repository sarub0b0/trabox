require_relative './option'

module Trabox
  module Command
    module Relay
      class << self
        def configure
          yield config
        end

        def config
          @config ||= Configuration.new
        end

        # @return [Option::Relayer]
        def relayer_config
          config.relayer
        end

        # @return [Option::Publisher]
        def publisher_config
          config.publisher
        end
      end

      class Configuration
        # @!attribute [rw] relayer
        #   @return [Option::Relayer]
        # @!attribute [rw] publisher
        #   @return [Option::Publisher]
        attr_accessor :relayer, :publisher

        def initialize
          @relayer = Option::Relayer.new
          @publisher = Option::Publisher.new
        end

        def valid?
          @relayer.valid? && @publisher.valid?
        end
      end
    end
  end
end
