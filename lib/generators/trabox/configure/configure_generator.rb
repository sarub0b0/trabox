# frozen_string_literal: true

module Trabox
  class ConfigureGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_initializer
      copy_file 'initializer.rb', 'config/initializers/trabox.rb'
    end
  end
end
