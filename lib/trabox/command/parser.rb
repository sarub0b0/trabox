require 'optparse'

module Trabox
  module Command
    class Parser
      def initialize
        @parser = OptionParser.new(nil, 20) do |o|
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
        @parser.order!

        command = ARGV.shift

        return command unless command.nil?

        warn usage
        exit 1
      end

      def usage
        <<~USAGE
          #{@parser.help}
          \e[1mCommands\e[0m:
              r, relay            Relay events
              s, subscribe        Subscribe events
        USAGE
      end
    end
  end
end
