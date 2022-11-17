require_relative './relay/option_parser'

module Trabox
  module Command
    module Relay
      def self.perform
        options = Options.new

        publisher = Trabox::PubSub::Publisher.new options.publisher.topic_id

        relayer = Trabox::Relay::Relayer.new(
          publisher,
          limit: options.relayer.limit,
          ordering_key: options.relayer.ordering_key,
          lock: options.relayer.lock,
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
