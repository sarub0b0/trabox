module Trabox
  module Relay
    # publish対象の複数モデルからデータを集約するモジュール
    module RelayableModels
      # @return [Array<Class>]
      def self.list
        if @models.nil?
          load_models

          @models = ApplicationRecord.descendants.filter do |klass|
            klass.ancestors.include?(Relayable)
          end
        end

        Rails.logger.debug "Relayed event models: #{@models.map { |model| model.name.underscore }}"

        @models
      end

      def self.load_models
        return if Rails.application.config.eager_load

        # test, developmentモードは遅延読み込みのためmodelsをロードする
        Rails.logger.debug 'Load models'

        Dir["#{Rails.root}/app/models/**/*.rb"].each do |file|
          require_dependency file
        end
      end

      private_class_method :load_models
    end
  end
end
