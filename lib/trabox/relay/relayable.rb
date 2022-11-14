# 未publishなレコードやpublish完了時のレコード操作を追加するためのモジュール
module Trabox
  module Relay
    module Relayable
      extend ActiveSupport::Concern

      included do
        # @param limit [Integer]
        scope :unpublished, lambda { |limit: DEFAULT_SELECT_LIMIT|
          where(published_at: nil).limit(limit).order(created_at: :asc)
        }
      end

      # message_idとpublished_atを更新する
      # publishした結果からpublishした時間を取得できないため、Timeクラスを使用する
      #
      # @param message_id [String]
      def published_done!(message_id)
        raise ArgumentError if message_id.blank?

        update!(message_id: message_id, published_at: Time.current.to_formatted_s(:iso8601))

        Rails.logger.debug "Event record updated. message_id=#{message_id}"
      end
    end
  end
end
