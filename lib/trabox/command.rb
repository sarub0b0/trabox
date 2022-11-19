require 'rails/command'

require 'trabox/command/parser'

require 'trabox/commands/config'
require 'trabox/commands/relay'
require 'trabox/commands/subscribe'

module Trabox
  module Command
    def self.invoke(command)
      require_relative './runner'
      require_relative './logger'

      case command
      when 'r', 'relay'
        Trabox::Command::Relay.perform
      when 's', 'subscribe'
        Trabox::Command::Subscribe.perform
      else
        raise "no such command: #{command}"
      end
    end
  end
end
