require 'google/cloud/pubsub'

# Google::Cloud::PubSub::Topicのラッパー
module Trabox
  module PubSub
    module Provier
      module Google
        LOG_PREFIX = '[google pubsub]'.freeze

        class Publisher
          # @param topic_id [String]
          # @param opts [Hash] Google::Cloud::PubSub options
          # @option opts [Boolean] :enable_message_ordering enable_message_ordering
          def initialize(topic_id, opts = {})
            raise ArgumentError, "topic_id must be specified." if topic_id.blank?

            # @type [Google::Cloud::PubSub::Project]
            @pubsub = ::Google::Cloud::PubSub.new

            # @type [Google::Cloud::PubSub::Topic]
            @topic = @pubsub.topic topic_id

            raise "'#{topic_id}' does not exist." if @topic.nil?

            @topic.enable_message_ordering! if opts[:enable_message_ordering]
          rescue StandardError => e
            Rails.logger.error "#{LOG_PREFIX} #{e.message}"
            raise
          end

          # @param message [String] publishするメッセージ
          # @param opts [Hash] Google::Cloud::PubSub options
          # @option opts [Boolean] :ordering_key
          #
          # @return message_id [String]
          def publish(message, opts = {})
            raise ArgumentError, 'published message must not be blank' if message.blank?

            published_message = @topic.publish message, **opts

            Rails.logger.debug "#{LOG_PREFIX} message published. " \
              "message_id=#{published_message.message_id} options=#{opts}"

            published_message.message_id
          rescue StandardError => e
            Rails.logger.error "#{LOG_PREFIX} #{e.message}"
            raise
          end
        end

        class Subscriber
          # @param subscription_id [String]
          # @param opts [Hash] Google::Cloud::PubSub options
          def initialize(subscription_id, _opts = {})
            @pubsub = Google::Cloud::Pubsub.new
            @subscription = @pubsub.subscription subscription_id
            @on_error = []

            Rails.logger.info "Subscription '#{subscription_id}': message ordering is #{@subscription.message_ordering?}."
          end

          def listen(_opts = {}, &callback)
            subscriber = @subscription.listen do |received_message|
              callback.call(received_message)

              received_message.acknowledge!
            end

            @on_error.each do |&cb|
              subscriber.on_error(&cb)
            end

            Rails.logger.info 'Listening subscrition...'
            subscriber.start.wait!
          end

          def on_error(&callback)
            @on_error << callback
          end
        end
      end
    end
  end
end
