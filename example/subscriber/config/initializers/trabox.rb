# Trabox::Metric.setup unless Rails.env.test?

ENV['PUBSUB_EMULATOR_HOST'] ||= '127.0.0.1:8085'
ENV['GOOGLE_CLOUD_PROJECT'] ||= 'trabox'

Trabox::Command::Subscribe.configure do |config|
  config.log_level = ENV['TRABOX_LOG_LEVEL']&.downcase&.to_sym || :info

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
    before_listen_acknowledge_callbacks:,
    after_listen_acknowledge_callbacks: [],
    error_listen_callbacks: []
  )
end
