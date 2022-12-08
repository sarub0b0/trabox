# frozen_string_literal: true

require_relative 'lib/trabox/version'

Gem::Specification.new do |spec|
  spec.name        = 'trabox'
  spec.version     = Trabox::VERSION
  spec.authors     = ['kosay']
  spec.email       = ['ekr59uv25@gmail.com']
  spec.summary     = 'Transactional-Outbox for Rails'
  spec.description = 'Transactional-Outbox for Rails'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/sarub0b0/trabox'

  spec.bindir = 'exe'
  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.executables = Dir['exe/**'].map { |f| File.basename(f) }

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'dogstatsd-ruby', '~> 5.5'
  spec.add_dependency 'google-cloud-pubsub', '~> 2.13'
  spec.add_dependency 'mysql2', '~> 0.5', '>= 0.5.4'
  spec.add_dependency 'optparse', '~> 0.2', '>= 0.2.0'
  spec.add_dependency 'rails', '~> 6.0', '>= 6.0.0'
end
