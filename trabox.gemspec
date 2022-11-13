require_relative 'lib/trabox/version'

Gem::Specification.new do |spec|
  spec.name        = 'trabox'
  spec.version     = Trabox::VERSION
  spec.authors     = ['kosay']
  spec.email       = ['ekr59uv25@gmail.com']
  spec.summary     = 'Transactional-Outbox for Rails'
  spec.description = 'Transactional-Outbox for Rails'
  spec.license     = 'MIT'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.1.7'
end
