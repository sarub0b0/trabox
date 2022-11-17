require 'rails/command'

require 'trabox/command/parser'

require 'trabox/commands/relay'
require 'trabox/commands/subscribe'

module Trabox
  module Command
    def self.invoke(command)
      case command
      when 'relay'
        Trabox::Commands::Relay.perform
      when 'subscribe'
        Trabox::Commands::Subscribe.perform
      else
        raise "no such command: #{command}"
      end
    end
  end
end
