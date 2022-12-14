module Trabox
  module Command
    class Configuration
      DEFAULT_LOG_LEVEL = :info
      # @!attribute [rw] log_level
      #   @return [Symbol]
      attr_accessor :log_level

      def initialize
        @log_level = ENV['TRABOX_LOG_LEVEL']&.downcase&.to_sym || DEFAULT_LOG_LEVEL
      end
    end
  end
end
