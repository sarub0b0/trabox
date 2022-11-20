Trabox::Command::Relay.configure do |config|
  config.relayer.limit = 10
  config.relayer.lock = true
  config.relayer.interval = 5

  config.relayer.ordering_key = ->(klass, _model) { klass.name.underscore }

  config.publisher.topic_id = 'trabox'
  config.publisher.message_ordering = true
end

Trabox::Command::Subscribe.configure do |config|
  config.subscriber.subscription_id = 'trabox-sub'

  config.subscriber.listen_callback = lambda do |received_message|
    Rails.logger.debug received_message
  end

  # config.subscriber.error_callbacks << ->(err) { Rails.logger.error err }
end
