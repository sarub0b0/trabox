require_relative './relay/option_parser'

module Trabox
  module Command
    module Relay
      def self.perform
        options = Options.new

        publisher = Trabox::PubSub::Publisher.new options.publisher.topic_id

        relayer = Trabox::Relay::Relayer.new(
          publisher,
          limit: config.limit,
          ordering_key: config.ordering_key,
          lock: config.lock,
        )

        loop do
          begin
            relayer.perform
          rescue StandardError => e
            Rails.logger.error e
          end

          sleep options.relayer.interval
        end
      end
    end
  end
end
