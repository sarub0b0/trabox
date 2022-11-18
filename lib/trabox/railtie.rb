module Trabox
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      p 'before_configuration'
    end

    config.before_initialize do
      p 'before_initialize'
    end

    config.to_prepare do
      p 'to_prepare'
    end

    config.before_eager_load do
      p 'before_eager_load'
    end

    config.after_initialize do
      p 'after_initialize'
    end
  end
end
