# frozen_string_literal: true

module Trabox
  module Command
    module Runner
      RAILS_ROOT = ENV['RAILS_ROOT'] || '.'
      APP_PATH ||= "#{RAILS_ROOT}/config/application"

      def self.load_runner
        require "#{RAILS_ROOT}/config/boot"

        require APP_PATH
        Rails.application.require_environment!
        Rails.application.load_runner
      end
    end
  end
end
