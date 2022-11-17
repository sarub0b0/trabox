require 'rails/command'

require 'trabox/command/parser'

require 'trabox/commands/relay'
require 'trabox/commands/subscribe'

module Trabox
  module Command
    def self.invoke(command)
      case command
      when 'relay'
        Trabox::Command::Relay.perform
      when 'subscribe'
        Trabox::Command::Subscribe.perform
      else
        raise "no such command: #{command}"
      end
    end
  end
end
