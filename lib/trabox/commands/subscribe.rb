require_relative './subscribe/argument_parser'
require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        config_activate

        require_relative './common/runner'

        trap('USR1') do
          Rails.logger.level = :debug
        end

        trap('USR2') do
          Rails.logger.level = config.log_level
        end

        config.check

        Rails.logger.level = config.log_level

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
