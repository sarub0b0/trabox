require_relative './relay/argument_parser'
require_relative './relay/configuration'
require_relative './common/runner'

module Trabox
  module Command
    module Relay
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

        relayer = Trabox::Relay::Relayer.new(
          config.publisher,
          limit: config.limit,
          lock: config.lock
        )

        interval = config.interval

        loop do
          begin
            relayer.perform

            Metric.service_check('relay.service.check', Metric::SERVICE_OK)
          rescue StandardError => e
            Rails.logger.error e

            ActiveRecord::Base.clear_all_connections!

            Metric.service_check('relay.service.check', Metric::SERVICE_CRITICAL)
          end

          sleep interval
        end
      end
    end
  end
end
