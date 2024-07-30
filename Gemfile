source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in trabox.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
gem 'ammeter', '~> 1.1'

gem 'byebug'
gem 'database_cleaner-active_record', '~> 2.0'
gem 'factory_bot'
gem 'rspec-rails'

# dev tools

gem 'pry-byebug'
gem 'rubocop'
gem 'ruby-lsp'

if RUBY_VERSION >= '3.0.0'
  gem 'google-protobuf'
elsif RUBY_VERSION >= '2.7.0'
  gem 'google-protobuf', '~> 3.25.0'
else
  gem 'google-protobuf', '< 3.25.5'
end
