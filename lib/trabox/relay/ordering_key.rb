module Trabox
  module Relay
    class OrderingKey
      def initialize(key)
        @key = if key.is_a?(Proc)
                 key
               elsif key.instance_of?(String)
                 -> { key }
               else
                 raise ArgumentError, "OrderingKey.new should be set to Proc or String."
               end
      end

      def call(*arg)
        key = @key.call(*arg)

        raise "OrderingKey#call should be returned String type." unless key.instance_of?(String)

        key
      end
    end
  end
end
