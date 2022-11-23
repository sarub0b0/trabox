require 'trabox/pubsub/provider/google'

module Trabox
  module PubSub
    class Subscriber
      def initialize(subscription_id, opts = {})
        @subscriber = Provider::Google::Subscriber.new subscription_id, opts
      end

      def listen(opts = {}, error_callbacks:, &callback)
        @subscriber.listen opts, error_callbacks: error_callbacks, &callback
      end
    end
  end
end

class Subscriber
  # @param subscription_id [String]
  # @param opts [Hash] Google::Cloud::PubSub options
  def initialize(subscription_id, _opts = {})
    @pubsub = ::Google::Cloud::PubSub.new
    @subscription = @pubsub.subscription subscription_id

    raise "Subscription-ID='#{subscription_id}' does not exist." if @subscription.nil?

    Rails.logger.info "Subscription '#{subscription_id}': message ordering is #{@subscription.message_ordering?}."
  end

  def listen(opts = {}, error_callbacks: [], &callback)
    subscriber = @subscription.listen(**opts) do |received_message|
      callback.call(received_message)

      received_message.acknowledge!
    end

    binding.pry
    error_callbacks.each do |cb|
      subscriber.on_error(&cb)
    end

    Rails.logger.info 'Listening subscrition...'
    subscriber.start.wait!
  end
end
