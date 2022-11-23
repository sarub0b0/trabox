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
      end

      class Configuration
        DEFAULT_SELECT_LIMIT = 3
        DEFAULT_INTERVAL = 5
        DEFAULT_LOCK = true

        # @!attribute [rw] limit
        #   @return [Integer]
        # @!attribute [rw] interval
        #   @return [Integer]
        # @!attribute [rw] lock
        #   @return [Boolean, String]
        # @!attribute [rw] publisher
        #   @return [Trabox::Publisher]
        attr_accessor :limit,
                      :interval,
                      :lock,
                      :publisher

        def initialize
          @limit = ENV['TRABOX_RELAYER_LIMIT'] || DEFAULT_SELECT_LIMIT
          @interval = ENV['TRABOX_RELAYER_INTERVAL'] || DEFAULT_INTERVAL
          @lock = ENV['TRABOX_RELAYER_LOCK'] || DEFAULT_LOCK
        end

        def interval=(interval)
          @interval = interval.to_i
        end

        def valid?
          @publisher.is_a?(Trabox::Publisher)
        end
      end
    end
  end
end
