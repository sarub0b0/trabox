module Trabox
  module Relay
    class Relayer
      # @param publisher [Trabox::PubSub::Publisher]
      # @param limit [Integer] SELECT文のLIMIT
      # @param lock [Boolean, String] ActiveRecord lock argument
      def initialize(publisher, limit: DEFAULT_SELECT_LIMIT, lock: true)
        raise ArgumentError unless publisher.respond_to?(:publish)

        @publisher = publisher
        @limit = limit
        @lock = lock
      end

      def perform
        RelayableModels.list.each do |model|
          model.transaction do
            unpublished_events = begin
              model.lock(@lock).unpublished limit: @limit
            rescue StandardError
              Metric.increment('find_events_error_count',
                               tags: ["event-type:#{model.name.underscore}"])
              raise
            end

            unpublished_events.each do |event|
              Metric.increment('unpublished_event_count',
                               tags: ["event-type:#{event.class.name.underscore}", "event-id:#{event.id}"])

              publish_and_commit(event)

              Metric.increment('published_event_count',
                               tags: ["event-type:#{event.class.name.underscore}", "event-id:#{event.id}"])
            end

            Rails.logger.info "Published events. (#{model.name.underscore}=#{unpublished_events.size})"
          end
        end
      end

      private

      def publish_and_commit(event)
        begin
          message_id = @publisher.publish event
        rescue StandardError
          Metric.increment('published_event_error_count',
                           tags: ["event-type:#{event.class.name.underscore}", "event-id:#{event.id}"])
          raise
        end

        begin
          event.published_done! message_id
        rescue StandardError
          Metric.increment('update_event_record_error_count',
                           tags: ["event-type:#{event.class.name.underscore}", "event-id:#{event.id}"])
          raise
        end
      end
    end
  end
end
