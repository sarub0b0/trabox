require_relative './relay/argument_parser'
require_relative './relay/configuration'

module Trabox
  module Command
    module Relay
      def self.perform
        ArgumentParser.parse!

        raise unless config.valid?

        publisher = config.publisher

        relayer = Trabox::Relay::Relayer.new(
          publisher,
          limit: config.limit,
          lock: config.lock
        )

        interval = config.interval

        loop do
          relayer.perform

          sleep interval
        rescue StandardError => e
          Rails.logger.error e

          ActiveRecord::Base.clear_all_connections!
        end
      end
    end
  end
end
