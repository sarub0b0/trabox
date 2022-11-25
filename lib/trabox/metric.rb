# frozen_string_literal: true

require 'datadog/statsd'

module Trabox
  # Traboxのメトリクス
  #
  # - unpublished_event_count: パブリッシュするイベント数
  # - published_event_count: パブリッシュしたイベント数
  # - find_events_error_count: パブリッシュするイベントの取得に失敗した数
  # - publish_event_error_count: イベントのパブリッシュに失敗した数
  # - update_event_record_error_count: パブリッシュしたイベントのカラム更新に失敗した数
  module Metric
    NAMESPACE = ENV.fetch('METRIC_NAMESPACE', 'trabox')
    LOG_PREFIX = '[metric]'
    SERVICE_OK = Datadog::Statsd::OK
    SERVICE_CRITICAL = Datadog::Statsd::CRITICAL

    class << self
      attr_reader :statsd

      # Datadog::Statsd.new arguments
      def setup(*args, **kwargs)
        binding.pry
        @statsd = Datadog::Statsd.new(*args, **kwargs)
      end

      def service_check(status, opts = {})
        name = metric_name('service.check')

        @statsd&.service_check(name, status, opts)

        status = case status
                 when SERVICE_OK
                   'ok'
                 when SERVICE_CRITICAL
                   'critical'
                 else
                   'undefined'
                 end

        Rails.logger.debug "#{LOG_PREFIX} type=service_check name=#{name} status=#{status} opts=#{opts}"
      end

      def count(name, count, opts = {})
        name = metric_name(name)

        @statsd&.count(name, count, opts)

        Rails.logger.debug "#{LOG_PREFIX} type=count name=#{name} count=#{count} opts=#{opts}"
      end

      def increment(name, opts = {})
        count name, 1, opts
      end

      def decrement(name, opts = {})
        count name, -1, opts
      end

      def distribution(name, value, opts = {})
        name = metric_name(name)

        @statsd&.distribution name, value, opts

        Rails.logger.debug "#{LOG_PREFIX} type=distribution name=#{name} value=#{value} opts=#{opts}"
      end

      def distribution_time(name, opts = {}, &block)
        name = metric_name(name)

        @statsd&.distribution_time name, opts, &block

        Rails.logger.debug "#{LOG_PREFIX} type=distribution_time name=#{name} opts=#{opts}"
      end

      def event(title, text, opts = {})
        @statsd&.event title, text, opts

        Rails.logger.debug "#{LOG_PREFIX} type=event title=#{title} opts=#{opts}"
      end

      def gauge(name, value, opts = {})
        name = metric_name(name)

        @statsd&.gauge name, value, opts

        Rails.logger.debug "#{LOG_PREFIX} type=gauge name=#{name} value=#{value} opts=#{opts}"
      end

      def histogram(name, value, opts = {})
        name = metric_name(name)

        @statsd&.histogram name, value, opts

        Rails.logger.debug "#{LOG_PREFIX} type=histogram name=#{name} value=#{value} opts=#{opts}"
      end

      def set(name, value, opts = {})
        name = metric_name(name)

        @statsd&.set name, value, opts

        Rails.logger.debug "#{LOG_PREFIX} type=set name=#{name} value=#{value} opts=#{opts}"
      end

      def time(name, opts = {}, &block)
        name = metric_name(name)

        @statsd&.time name, opts, &block

        Rails.logger.debug "#{LOG_PREFIX} type=time name=#{name} opts=#{opts}"
      end

      def timing(name, ms, opts = {})
        name = metric_name(name)

        @statsd&.timing name, ms, opts

        Rails.logger.debug "#{LOG_PREFIX} type=timing name=#{name} ms=#{ms} opts=#{opts}"
      end

      def batch
        yield self
      end

      def close(**kwargs)
        @statsd&.close(**kwargs)

        Rails.logger.debug "#{LOG_PREFIX} type=close opts=#{kwargs}"
      end

      def flush(**kwargs)
        @statsd&.flush(**kwargs)

        Rails.logger.debug "#{LOG_PREFIX} type=flush opts=#{kwargs}"
      end

      private

      def metric_name(name)
        "#{NAMESPACE}.#{name}"
      end
    end
  end
end
