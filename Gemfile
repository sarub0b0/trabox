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

if RUBY_VERSION >= '2.7.0'
  gem 'factory_bot', '>= 6.2.0'
else
  gem 'factory_bot', '~> 6.2.0'
end

gem 'rspec-rails', '>= 5.0.0'

# dev tools

gem 'pry-byebug', '~> 3.10' if RUBY_VERSION >= '2.7.0'
gem 'rubocop', '~> 1.38'
gem 'ruby-lsp', '~> 0.17.0' if RUBY_VERSION >= '3.0.0'

if RUBY_VERSION >= '2.7.0'
  gem 'google-protobuf', '~> 3.24.0'
else
  gem 'google-protobuf', '< 3.24.0'
end
