require_relative './relay/argument_parser'
require_relative './relay/configuration'
require_relative './common/runner'

module Trabox
  module Command
    module Relay
      def self.perform
        config_activate

        Runner.load_runner

        trap('USR1') do
          Rails.logger.level = :debug
        end

        trap('USR2') do
          Rails.logger.level = config.log_level
        end

        ArgumentParser.parse!

        config.check

        Rails.logger.level = config.log_level

        publisher = config.publisher

        relayer = Trabox::Relay::Relayer.new(
          publisher,
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
