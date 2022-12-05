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

  spec.bindir = 'exe'
  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.executables = Dir['exe/**'].map { |f| File.basename(f) }

  spec.add_dependency 'dogstatsd-ruby'
  spec.add_dependency 'google-cloud-pubsub'
  spec.add_dependency 'mysql2'
  spec.add_dependency 'optparse'
  spec.add_dependency 'rails'
end
