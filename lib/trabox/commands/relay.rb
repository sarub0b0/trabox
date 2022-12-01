require_relative './relay/argument_parser'
require_relative './relay/configuration'

module Trabox
  module Command
    module Relay
      def self.perform
        config_activate

        require_relative './runner'
        require_relative './logger'

        ArgumentParser.parse!

        config.check

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
