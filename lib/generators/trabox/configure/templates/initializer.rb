# Trabox::Metric.setup unless Rails.env.test?

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

Trabox::Command::Subscribe.configure do |config|
  config.log_level = :info

  before_listen_acknowledge_callbacks = []
  before_listen_acknowledge_callbacks << lambda do |received_message|
    Rails.logger.info "id=#{received_message.message_id} message=#{received_message.data} ordering_key=#{received_message.ordering_key}"
  end

  # after_listen_acknowledge_callbacks = []
  # after_listen_acknowledge_callbacks << lambda do |_received_message|
  # end

  # error_listen_callbacks = []
  # error_listen_callbacks << lambda do |_exception|
  # end

  config.subscriber = Trabox::Subscriber::Google::Cloud::PubSub.new(
    'trabox-sub',
    listen_options: {},
    before_listen_acknowledge_callbacks: before_listen_acknowledge_callbacks,
    after_listen_acknowledge_callbacks: [],
    error_listen_callbacks: []
  )
end
