# Trabox::Metric.setup unless Rails.env.test?

ENV['PUBSUB_EMULATOR_HOST'] ||= '127.0.0.1:8085'
ENV['GOOGLE_CLOUD_PROJECT'] ||= 'trabox'

Trabox::Command::Relay.configure do |config|
  config.limit = 10

  # ref: https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-lock-21
  config.lock = true
  config.interval = 5
  config.log_level = :info

  # String or Proc
  ordering_key = Trabox::Publisher::Google::Cloud::PubSub::OrderingKey.new ->(event) { event.model_name.name }

  config.publisher = Trabox::Publisher::Google::Cloud::PubSub.new(
    'trabox',
    message_ordering: true,
    ordering_key: ordering_key
  )
end
