require 'google/cloud/pubsub'

# Google::Cloud::PubSub::Topicのラッパー
module Trabox
  module Publisher
    module Google
      module Cloud
        class PubSub
          include Trabox::Publisher

          LOG_PREFIX = '[google pubsub]'.freeze

          class OrderingKey
            # @param key [Proc(ActiveRecord), String]
            def initialize(key)
              @key = if key.is_a?(Proc)
                       key
                     elsif key.instance_of?(String)
                       ->(*) { key }
                     else
                       raise ArgumentError, 'OrderingKey.new should be set to Proc or String.'
                     end
            end

            # @return [String]
            def call(*args)
              key = @key.call(*args)

              raise 'OrderingKey#call should be returned String type.' unless key.instance_of?(String)

              key
            end
          end

          # @param topic_id [String]
          # @param message_ordering [Boolean] enable_message_ordering
          # @param ordering_key [OrderingKey]
          def initialize(topic_id, message_ordering: true, ordering_key: nil)
            raise ArgumentError, 'topic_id must be specified.' if topic_id.blank?

            # @type [Google::Cloud::PubSub::Project]
            @pubsub = ::Google::Cloud::PubSub.new

            # @type [Google::Cloud::PubSub::Topic]
            @topic = @pubsub.topic topic_id

            @ordering_key = ordering_key

            raise "Topic-ID='#{topic_id}' does not exist." if @topic.nil?

            @topic.enable_message_ordering! if message_ordering
          rescue StandardError => e
            Rails.logger.error "#{LOG_PREFIX} #{e.message}"
            raise
          end

          # @param event [ActiveRecord] publishするイベント
          # @return message_id [String]
          def publish(event)
            raise ArgumentError, 'event should be set to trabox:model' unless event.respond_to?(:event_data)

            message = event.event_data

            raise ArgumentError, 'published message must not be blank' if message.blank?

            published_message = if @ordering_key
                                  @topic.publish message, ordering_key: @ordering_key.call(event)
                                else
                                  @topic.publish message
                                end

            Rails.logger.debug "#{LOG_PREFIX} message published. " \
              "message_id=#{published_message.message_id} ordering_key=#{published_message.ordering_key}"

            published_message.message_id
          rescue StandardError => e
            Rails.logger.error "#{LOG_PREFIX} #{e.message}"
            raise
          end
        end
      end
    end
  end
end
