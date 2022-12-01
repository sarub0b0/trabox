require_relative './subscribe/argument_parser'
require_relative './subscribe/configuration'
require_relative './common/runner'

module Trabox
  module Command
    module Subscribe
      class << self
        def prepare
          config_activate

          Runner.load_runner

          setup_debugging_signal_handler

          ArgumentParser.parse!

          config.check

          Rails.logger.level = config.log_level
        end

        def setup_debugging_signal_handler
          trap('USR1') do
            Rails.logger.level = :debug
          end

          trap('USR2') do
            Rails.logger.level = config.log_level
          end
        end
      end

      def self.perform
        prepare

        subscriber = config.subscriber

        Metric.service_check('subscribe.service.check', Metric::SERVICE_OK)

        begin
          subscriber.subscribe
        rescue StandardError => e
          Rails.logger.error e

          Metric.service_check('subscribe.service.check', Metric::SERVICE_CRITICAL)
        end
      end
    end
  end
end
