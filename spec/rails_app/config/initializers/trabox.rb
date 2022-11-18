Trabox::Command::Relay.configure do |config|
  config.limit = 10
  config.ordering_key = ->(klass, _model) { "#{klass.name.underscore}" }
  config.lock = true
  config.interval = 10
  config.topic_id = ENV['TRABOX_PUBSUB_TOPIC_ID']
end

Trabox::Command::Subscribe.configure do |config|
  config.subscription_id = ENV['TRABOX_PUBSUB_SUBSCRIPTION_ID']

  config.listen_callback = lambda do |m|
    pp "id=#{m.message_id} data=#{m.data} ordering-key=#{m.ordering_key}"
  end
end
