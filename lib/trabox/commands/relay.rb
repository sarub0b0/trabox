require_relative './relay/argument_parser'
require_relative './relay/configuration'

module Trabox
  module Command
    module Relay
      def self.perform
        ArgumentParser.parse!

        raise unless config.valid?

        publisher = Trabox::PubSub::Publisher.new(
          publisher_config.topic_id,
          message_ordering: publisher_config.message_ordering
        )

        relayer = Trabox::Relay::Relayer.new(
          publisher,
          limit: relayer_config.limit,
          ordering_key: relayer_config.ordering_key,
          lock: relayer_config.lock
        )

        begin
          loop do
            relayer.perform

            sleep relayer_config.interval
          end
        rescue StandardError => e
          Rails.logger.error e

          ActiveRecord::Base.clear_all_connections!
        end
      end
    end
  end
end
