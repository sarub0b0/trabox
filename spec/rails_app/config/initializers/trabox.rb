Trabox::Command::Relay.configure do |config|
  config.relayer.limit = 10
  config.relayer.lock = true
  config.relayer.interval = 10
  config.relayer.ordering_key = ->(klass, _model) { klass.name.underscore }

  config.publisher.topic_id = ENV['PUBSUB_TOPIC_ID']
  config.publisher.message_ordering = true
end

Trabox::Command::Subscribe.configure do |config|
  config.subscription_id = ENV['PUBSUB_SUBSCRIPTION_ID']

  config.listen_callback = lambda do |m|
    pp "id=#{m.message_id} data=#{m.data} ordering-key=#{m.ordering_key}"
  end
end
