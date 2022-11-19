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

            o.on('-s SUBSCRIPTION_ID', '--subscription-id', String)
          end

          @parser.parse!(into: opts)

          opts.transform_keys { |k| k.to_s.underscore.to_sym }
        end

        def config_overwrite(opts)
          Subscribe.config.subscription_id = opts[:subscription_id] if opts[:subscription_id]
        end
      end
    end
  end
end
