require 'active_support/core_ext/string/inflections'
module Trabox
  module Commands
    module Subscribe
      class Option
        attr_reader :description, :option, :command_name

        def initialize
          @description = 'Subscribe events'
          @command_name = File.basename(__FILE__, '.*')
          @option = OptionParser.new do |o|
            o.banner = "Usage: #{o.program_name} #{@command_name} [OPTIONS]"
            o.version = VERSION
            o.on('-t TOPIC_ID', '--topic-id', :REQUIRED, 'required')
            o.on('-k KEY', '--ordering-key', :REQUIRED, 'required')
            o.on('-b NUM', '--batch-size', "optional (default: 3)", Integer)
            o.on('-i SEC', '--interval', "optional (default: 5)", Integer)
          end
        end

        def parse!(argv)
          option = {}
          @option.parse!(argv, into: option)
          option.transform_keys { |k| k.to_s.underscore.to_sym }
        end
      end

      def self.perform(_opts)
        binding.irb
        pp 'perform subscribe'
      end
    end
  end
end
