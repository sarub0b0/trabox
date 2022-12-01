require 'optparse'
require_relative './configuration'

module Trabox
  module Command
    module Relay
      class ArgumentParser
        def self.parse!
          new
        end

        def initialize
          opts = parse!

          config_overwrite(opts)
        end

        private

        def parse!
          opts = {}

          @parser = OptionParser.new do |o|
            o.banner = <<~BANNER
              \e[1mUsage\e[0m: \e[1mtrabox relay\e[0m [OPTIONS]

              Overwrite configuration

            BANNER

            o.on('-l NUM', '--limit', Integer)
            o.on('-i SEC', '--interval', Integer)
            o.on('-L', '--[no-]lock', TrueClass)
          end

          @parser.parse!(into: opts)

          opts.transform_keys { |k| k.to_s.underscore.to_sym }
        end

        def config_overwrite(opts)
          opts.each do |attr, val|
            next if val.nil?

            Relay.config.send("#{attr}=", val)
          end
        end
      end
    end
  end
end
