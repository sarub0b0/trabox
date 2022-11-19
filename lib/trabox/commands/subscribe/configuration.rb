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
        # @!attribute [rw] subscription_id
        #   @return [String]
        # @!attribute [rw] on_listen
        #   @return [Proc]
        attr_accessor :subscription_id, :listen_callback

        def initialize
          @subscription_id = ENV['TRABOX_SUBSCRIBER_SUBSCRIPTION_ID']
          @listen_callback = proc {}
        end

        def valid?
          if @subscription_id.nil?
            $stdout.puts 'topic-idを設定してください。'
            false
          else
            true
          end
        end
      end
    end
  end
end
