rails_root = ENV['RAILS_ROOT'] || '../'

APP_PATH ||= File.expand_path("#{rails_root}/config/application", __dir__)
require_relative "#{rails_root}/config/boot"

require APP_PATH
Rails.application.require_environment!
Rails.application.load_runner
