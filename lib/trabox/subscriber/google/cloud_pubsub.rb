module Trabox
  module Subscriber
    module Google
      module Cloud
        class PubSub
          include Subscriber

          # @param subscription_id [String]
          # @param listen_options [Hash] listen method options
          # @param before_listen_acknowledge_callbacks [Array<Proc>]
          # @param after_listen_acknowledge_callbacks [Array<Proc>]
          # @param error_listen_callbacks [Array<Proc>]
          def initialize(subscription_id,
                         listen_options: {},
                         before_listen_acknowledge_callbacks: [],
                         after_listen_acknowledge_callbacks: [],
                         error_listen_callbacks: [])

            @listen_options = listen_options
            @before_listen_acknowledge_callbacks = before_listen_acknowledge_callbacks
            @after_listen_acknowledge_callbacks = after_listen_acknowledge_callbacks
            @error_listen_callbacks = error_listen_callbacks

            @pubsub = ::Google::Cloud::PubSub.new

            @subscription = @pubsub.subscription subscription_id

            raise "Subscription-ID='#{subscription_id}' does not exist." if @subscription.nil?

            Rails.logger.info "Subscription '#{subscription_id}': message ordering is #{@subscription.message_ordering?}."
          end

          def subscribe
            subscriber = @subscription.listen(**@listen_options) do |received_message|
              @before_listen_acknowledge_callbacks.each do |cb|
                cb.call(received_message)
              end

              received_message.acknowledge!

              @after_listen_acknowledge_callbacks.each do |cb|
                cb.call(received_message)
              end

              Metric.service_check('subscribe.service.check', Metric::SERVICE_OK)
            end

            subscriber.on_error do |_|
              Metric.service_check('subscribe.service.check', Metric::SERVICE_CRITICAL)
            end

            @error_listen_callbacks.each do |cb|
              subscriber.on_error(&cb)
            end

            Rails.logger.info 'Listening subscrition...'
            subscriber.start.wait!
          end
        end
      end
    end
  end
end
