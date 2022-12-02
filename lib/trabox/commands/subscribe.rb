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

          ArgumentParser.parse!

          config.check

          Rails.logger.level = config.log_level
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
