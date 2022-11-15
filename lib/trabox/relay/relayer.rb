module Trabox
  module Relay
    class Relayer
      # @param publisher [Trabox::PubSub::Publisher]
      # @param limit [Integer] SELECT文のLIMIT
      # @param ordering_key [String]
      def initialize(publisher, limit: DEFAULT_SELECT_LIMIT, ordering_key: nil)
        raise TypeError unless publisher.instance_of?(Trabox::PubSub::Publisher)

        @publisher = publisher
        @limit = limit
        @ordering_key = ordering_key
      end

      def relay
        RelayableModels.list.each do |model|
          model.transaction do
            unpublished_events = model.lock.unpublished limit: @limit

            unpublished_events.each do |event|
              publish_and_commit(event)
            end

            Rails.logger.info "Published events. (#{model.name.underscore}=#{unpublished_events.size})"
          end
        end
      end

      private

      def publish_and_commit(event)
        message_id = @publisher.publish(
          message: event.event_data,
          ordering_key: @ordering_key,
        )

        event.published_done!(message_id)
      end
    end
  end
end
