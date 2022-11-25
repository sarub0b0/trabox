Trabox::Metric.setup

Trabox::Command::Relay.configure do |config|
  config.limit = 10
  config.lock = true
  config.interval = 5

  config.publisher = Trabox::Publisher::Google::Cloud::PubSub.new(
    'trabox',
    message_ordering: true,
    ordering_key: Trabox::Publisher::Google::Cloud::PubSub::OrderingKey.new ->(event) { event.name.underscore }
  )
end

Trabox::Command::Subscribe.configure do |config|
  config.subscriber= Trabox::Subscriber::Google::Cloud::PubSub.new(
    'trabox-sub',
    listen_options: {},
    listen_callback: lambda do |received_message|
      Rails.logger.debug received_message
    end,
    error_callbacks:[],
  )
end
