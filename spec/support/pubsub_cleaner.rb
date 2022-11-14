class PubSubCleaner
  attr_accessor :topic, :subscription
  attr_reader :pubsub

  def initialize(topic_id: nil, subscription_id: nil)
    raise ArgumentError if topic_id.blank?
    raise ArgumentError if subscription_id.blank?

    @topic_id = topic_id
    @subscription_id = subscription_id

    @pubsub = Google::Cloud::PubSub.new
  end

  def setup
    clear

    @topic = @pubsub.create_topic @topic_id
    @topic.enable_message_ordering!
    @subscription = @topic.subscribe @subscription_id, message_ordering: true
  end

  def clear
    topic = @pubsub.topic @topic_id
    topic&.delete

    subscription = topic&.subscription @subscription_id
    subscription&.delete
  end
end
