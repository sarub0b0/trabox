require 'optparse'
require_relative './configuration'

module Trabox
  module Command
    module Subscribe
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
              \e[1mUsage\e[0m: \e[1mtrabox subscribe\e[0m [OPTIONS]

              Overwrite configuration

            BANNER

            o.on('--log-level LEVEL', String) { |v| v.downcase.to_sym }
          end

          @parser.parse!(into: opts)

          opts.transform_keys { |k| k.to_s.underscore.to_sym }
        end

        def config_overwrite(opts)
          opts.each do |attr, val|
            next if val.nil?

            Subscribe.config.send("#{attr}=", val)
          end
        end
      end
    end
  end
end
