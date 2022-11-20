# frozen_string_literal: true

module Option
  # Relayer用のオプション
  class Subscriber
    # @!attribute [rw] subscription_id
    #   @return [String]
    # @!attribute [rw] listen_callback
    #   @return [Proc]
    # @!attribute [rw] error_callbacks
    #   @return [Array<Proc>]
    attr_accessor :subscription_id, :listen_callback, :error_callbacks

    def initialize
      @subscription_id = ENV['TRABOX_SUBSCRIBER_SUBSCRIPTION_ID']
      @listen_callback = proc {}
      @error_callbacks = []
    end

    def valid?
      if @subscription_id.nil?
        $stdout.puts 'topic-idを設定してください。'
        false
      else
        true
      end
    end
  end
end
