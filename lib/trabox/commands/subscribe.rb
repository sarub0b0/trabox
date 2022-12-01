require_relative './subscribe/configuration'

module Trabox
  module Command
    module Subscribe
      def self.perform
        config_activate

        require_relative './runner'
        require_relative './logger'

        config.check

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
