module Trabox
  module Command
    module Common
      class Configuration
        DEFAULT_LOG_LEVEL = :info
        # @!attribute [rw] log_level
        #   @return [Symbol]
        attr_accessor :log_level

        def initialize
          @log_level = ENV['TRABOX_LOG_LEVEL'] || DEFAULT_LOG_LEVEL
        end
      end
    end
  end
end
