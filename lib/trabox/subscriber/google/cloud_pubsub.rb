module Trabox
  module Subscriber
    module Google
      module Cloud
        class PubSub
          include Subscriber

          # @param subscription_id [String]
          # @param listen_options [Hash] listen options
          def initialize(subscription_id, listen_options: {}, listen_callback: -> {}, error_callbacks: [])
            @pubsub = ::Google::Cloud::PubSub.new
            @subscription = @pubsub.subscription subscription_id
            @listen_options = listen_options
            @listen_callback = listen_callback
            @error_callbacks = error_callbacks

            raise "Subscription-ID='#{subscription_id}' does not exist." if @subscription.nil?

            Rails.logger.info "Subscription '#{subscription_id}': message ordering is #{@subscription.message_ordering?}."
          end

          def subscribe
            subscriber = @subscription.listen(**@listen_options) do |received_message|
              @listen_callback.call(received_message)

              received_message.acknowledge!

              Metric.service_check('subscribe.service.check', Metric::SERVICE_OK)
            end

            subscriber.on_error do |_e|
              Metric.service_check('subscribe.service.check', Metric::SERVICE_CRITICAL)
            end

            @error_callbacks.each do |cb|
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
