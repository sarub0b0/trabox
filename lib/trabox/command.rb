require 'rails/command'
require 'trabox/commands/relay'
require 'trabox/commands/subscribe'
require 'optparse'

module Trabox
  module Command
    class OptParse
      def initialize
        @opt = OptionParser.new(nil, 20) do |o|
          o.version = VERSION
          o.banner = "\e[1mUsage: #{o.program_name}\e[0m <COMMAND> [OPTIONS]"
          o.on_tail('-h', '--help', 'Print help information') do
            $stdout.puts usage
            exit 0
          end

          o.on_tail('-v', '--version', 'Print version information')
        end
      end

      def parse!
        @opt.order!

        command = ARGV.shift

        return command unless command.nil?

        warn usage
        exit 1
      end

      def usage
        <<~USAGE
          #{@opt.help}
          \e[1mCommands\e[0m:
              relay            Relay events
              subscribe        Subscribe events
        USAGE
      end
    end

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
