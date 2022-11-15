require 'optparse'

# runners/event_relay.rbで使用するコマンド引数のためのクラス
class Options
  # Relayer用のオプション
  class Relayer
    DEFAULT_ORDERING_KEY = nil
    DEFAULT_LIMIT = 3
    DEFAULT_INTERVAL = 5
    DEFAULT_LOCK = true

    # @!attribute [rw] ordering_key
    #   @return [String]
    # @!attribute [rw] limit
    #   @return [Integer]
    # @!attribute [rw] interval
    #   @return [Integer]
    # @!attribute [rw] lock
    #   @return [Boolean]

    attr_accessor :ordering_key,
                  :limit,
                  :interval,
                  :lock

    def initialize
      @ordering_key = DEFAULT_ORDERING_KEY
      @limit = DEFAULT_LIMIT
      @interval = DEFAULT_INTERVAL
      @lock = DEFAULT_LOCK
    end

    def valid?
      if @ordering_key.nil?
        $stdout.puts 'ordering-keyを設定してください。'
        false
      else
        true
      end
    end
  end

  # PubSub用のオプション
  class Publisher
    DEFAULT_TOPIC_ID = nil

    # @!attribute [rw] topic_id
    #   @return [String]
    attr_accessor :topic_id

    def initialize
      @topic_id = DEFAULT_TOPIC_ID
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

  # @!attribute [r] relayer
  #   @return [Relayer]
  # @!attribute [r] publisher
  #   @return [Publisher]
  attr_reader :relayer,
              :publisher

  def initialize
    options = optparse

    options_setup(options)

    validate
  end

  private

  DEFAULT_OPTIONS = {
    'ordering_key': Relayer::DEFAULT_ORDERING_KEY,
    'limit': Relayer::DEFAULT_LIMIT,
    'interval': Relayer::DEFAULT_INTERVAL,
    'lock': Relayer::DEFAULT_LOCK,
    'topic_id': Publisher::DEFAULT_TOPIC_ID,
  }.freeze

  def optparse
    options = DEFAULT_OPTIONS.clone(freeze: false)
    @opt = OptionParser.new do |o|
      o.banner = "\e[1mUsage\e[0m: \e[1mtrabox relay\e[0m [OPTIONS]"
      o.on('-t TOPIC_ID', '--topic-id', :REQUIRED, 'required')
      o.on('-k KEY', '--ordering-key', :REQUIRED, 'required')
      o.on('-l NUM', '--limit', "optional (default: #{Relayer::DEFAULT_LIMIT})", Integer)
      o.on('-i SEC', '--interval', "optional (default: #{Relayer::DEFAULT_INTERVAL})", Integer)
      o.on('-L', '--[no-]lock', "optional (default: #{Relayer::DEFAULT_LOCK})", TrueClass)
    end

    @opt.parse!(into: options)

    options.transform_keys { |k| k.to_s.underscore.to_sym }
  end

  def options_setup(options)
    @relayer = Relayer.new
    @relayer.ordering_key = options[:ordering_key]
    @relayer.limit = options[:limit]
    @relayer.interval = options[:interval]
    @relayer.lock = options[:lock]

    @publisher = Publisher.new
    @publisher.topic_id = options[:topic_id]
  end

  def validate
    return if @relayer.valid? && @publisher.valid?

    $stdout.puts @opt.help
    exit 1
  end
end
