module Trabox
  module Relay
    class Relayer
      # @param publisher [Trabox::PubSub::Publisher]
      # @param limit [Integer] SELECT文のLIMIT
      # @param ordering_key [OrderingKey]
      # @param lock [Boolean, String] ActiveRecord lock argument
      def initialize(publisher, limit: DEFAULT_SELECT_LIMIT, lock: true)
        raise TypeError unless publisher.is_a?(Trabox::Publisher)

        @publisher = publisher
        @limit = limit
        @lock = lock
      end

      def perform
        RelayableModels.list.each do |model|
          model.transaction do
            unpublished_events = model.lock(@lock).unpublished limit: @limit

            unpublished_events.each do |event|
              publish_and_commit(event)
            end

            Rails.logger.info "Published events. (#{model.name.underscore}=#{unpublished_events.size})"
          end
        end
      end

      private

      def publish_and_commit(event)
        message_id = @publisher.publish event

        event.published_done! message_id
      end
    end
  end
end
