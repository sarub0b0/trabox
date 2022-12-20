require 'bundler/setup'

require 'bundler/gem_tasks'

namespace :trabox do
  desc 'create topic/subscribe'
  task :pubsub_setup do
    require 'google/cloud/pubsub'
    require 'logger'

    ENV['PUBSUB_EMULATOR_HOST'] ||= 'localhost:8085'
    ENV['GOOGLE_CLOUD_PROJECT'] ||= 'trabox'

    logger = Logger.new($stdout)

    topic_id = ENV['PUBSUB_TOPIC_ID'] || 'trabox'
    subscription_id = ENV['PUBSUB_SUBSCRIPTION_ID'] || 'trabox-sub'

    pubsub = Google::Cloud::Pubsub.new

    ##################
    #  create topic  #
    ##################

    logger.info 'Create Topic'

    topic = pubsub.topic topic_id

    topic&.delete

    topic = pubsub.create_topic topic_id

    puts "Topic #{topic.name} created."

    #########################
    #  create subscription  #
    #########################

    logger.info 'Create Subscription'

    subscription = topic.subscription subscription_id

    subscription&.delete

    topic.subscribe subscription_id, message_ordering: true

    puts "Pull subscription #{subscription_id} created with message ordering."
  end
end
