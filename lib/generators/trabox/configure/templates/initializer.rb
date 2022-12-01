# Trabox::Metric.setup unless Rails.env.test?

Trabox::Command::Relay.configure do |config|
  config.limit = 10
  config.lock = true
  config.interval = 5

  ordering_key = Trabox::Publisher::Google::Cloud::PubSub::OrderingKey.new ->(event) { event.model_name.name }

  config.publisher = Trabox::Publisher::Google::Cloud::PubSub.new(
    'trabox',
    message_ordering: true,
    ordering_key: ordering_key
  )
end

Trabox::Command::Subscribe.configure do |config|
  listen_callback = lambda do |received_message|
    Rails.logger.info "id=#{received_message.message_id} message=#{received_message.data} ordering_key=#{received_message.ordering_key}"
  end

  config.subscriber = Trabox::Subscriber::Google::Cloud::PubSub.new(
    'trabox-sub',
    listen_options: {},
    listen_callback: listen_callback,
    error_callbacks: []
  )
end
