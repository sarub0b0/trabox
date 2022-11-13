require 'rails/generators/active_record/model/model_generator'

module Trabox
  class ModelGenerator < ActiveRecord::Generators::ModelGenerator
    source_root "#{base_root}/active_record/model/templates"

    class_option :polymorphic, type: :string, desc: 'add polymorphic column.'

    def initialize(*args)
      super

      add_attribute "#{options[:polymorphic]}:references{polymorphic}" if options[:polymorphic].present?

      add_attribute 'event_data:binary'
      add_attribute 'message_id:string'
      add_attribute 'published_at:datetime'
    end

    def insert_include
      inject_into_class File.join('app/models', class_path, "#{file_name}.rb"), class_name do
        "  include Trabox::Relay::Relayable\n"
      end
    end

    private

    def add_attribute(attribute)
      attributes << Rails::Generators::GeneratedAttribute.parse(attribute)
    end
  end
end
