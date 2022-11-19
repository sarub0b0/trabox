# frozen_string_literal: true

module Option
  # Relayer用のオプション
  class Relayer
    DEFAULT_SELECT_LIMIT = 3
    DEFAULT_ORDERING_KEY = nil
    DEFAULT_INTERVAL = 5
    DEFAULT_LOCK = true

    # @!attribute [rw] ordering_key
    #   @return [String]
    # @!attribute [rw] limit
    #   @return [Integer]
    # @!attribute [rw] interval
    #   @return [Integer]
    # @!attribute [rw] lock
    #   @return [Boolean, String]
    attr_accessor :ordering_key,
                  :limit,
                  :interval,
                  :lock

    def initialize
      @ordering_key = ENV['TRABOX_RELAYER_ORDERING_KEY'] || DEFAULT_ORDERING_KEY
      @limit = ENV['TRABOX_RELAYER_LIMIT'] || DEFAULT_SELECT_LIMIT
      @interval = ENV['TRABOX_RELAYER_INTERVAL'] || DEFAULT_INTERVAL
      @lock = ENV['TRABOX_RELAYER_LOCK'] || DEFAULT_LOCK
    end

    def ordering_key=(key)
      @ordering_key = Trabox::Relay::OrderingKey.new key
    end

    def interval=(interval)
      @interval = interval.to_i
    end

    def valid?
      true
    end
  end

  # PubSub用のオプション
  class Publisher
    DEFAULT_TOPIC_ID = nil
    DEFAULT_MESSAGE_ORDERING = true

    #
    # @!attribute [rw] topic_id
    #   @return [String]
    # @!attribute [rw] message_ordering
    #   @return [Boolean]
    attr_accessor :topic_id, :message_ordering

    # TODO: プロバイダー固有のパラメーターを渡したい
    def initialize
      @topic_id = ENV['TRABOX_PUBLISHER_TOPIC_ID'] || DEFAULT_TOPIC_ID
      @message_ordering = ENV['TRABOX_PUBLISHER_MESSAGE_ORDERING'] || DEFAULT_MESSAGE_ORDERING
    end

    def valid?
      if @topic_id.nil?
        $stdout.puts 'topic-idを設定してください。'
        false
      else
        true
      end
    end
  end
end
