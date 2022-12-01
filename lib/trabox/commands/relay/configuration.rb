require_relative '../common/configuration'

module Trabox
  module Command
    module Relay
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

      class Configuration < Command::Configuration
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
        #   @return [Trabox::Publisher, Class]
        attr_accessor :limit,
                      :interval,
                      :lock,
                      :publisher

        def initialize
          @limit = ENV['TRABOX_RELAYER_LIMIT'] || DEFAULT_SELECT_LIMIT
          @interval = ENV['TRABOX_RELAYER_INTERVAL'] || DEFAULT_INTERVAL
          @lock = ENV['TRABOX_RELAYER_LOCK'] || DEFAULT_LOCK

          super
        end

        def interval=(interval)
          @interval = interval.to_i
        end

        def check
          return if @publisher.respond_to?(:publish)

          raise 'Relay Configuration: config.publisher must be have :publish method.'
        end
      end
    end
  end
end
