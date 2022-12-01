# frozen_string_literal: true

module Trabox
  module Command
    module Runner
      RAILS_ROOT = ENV['RAILS_ROOT'] || '../'
      APP_PATH ||= File.expand_path("#{RAILS_ROOT}/config/application", __dir__)

      def self.load_runner
        require_relative "#{RAILS_ROOT}/config/boot"

        require APP_PATH
        Rails.application.require_environment!
        Rails.application.load_runner
      end
    end
  end
end
