module Trabox
  module Command
    module Relay
      DEFAULT_SELECT_LIMIT = 3

      class << self
        def configure
          yield config
        end

        def config
          @config ||= Config.new
        end
      end

      class Config
        # @!attribute [rw] limit
        #   @return [Integer]
        # @!attribute [rw] ordering_key
        #   @return [String, Proc]
        # @!attribute [rw] lock
        #   @return [Boolean]
        # @!attribute [rw] interval
        #   @return [Integer]
        attr_accessor :limit, :ordering_key, :lock, :interval

        # @!attribute [rw] topic_id
        #   @return [String]
        # @!attribute [rw] enable_message_ordering
        #   @return [Boolean]
        attr_accessor :topic_id, :enable_message_ordering

        def initialize
          @limit = DEFAULT_SELECT_LIMIT
          @ordering_key = nil
          @lock = true
          @interval = 5

          @topic_id = ENV['TRABOX_PUBSUB_TOPIC_ID']
          @enable_message_ordering = false
        end

        def ordering_key=(key)
          @ordering_key = Trabox::Relay::OrderingKey.new key
        end
      end
    end

    module Subscribe
      class << self
        def configure
          yield config
        end

        def config
          @config ||= Config.new
        end
      end

      class Config
        # @!attribute [rw] subscription_id
        #   @return [String]
        # @!attribute [rw] on_listen
        #   @return [Proc]
        attr_accessor :subscription_id, :listen_callback

        def initialize
          @subscription_id = ENV['TRABOX_PUBSUB_SUBSCRIPTION_ID']
          @listen_callback = proc {}
        end
      end
    end
  end
end
