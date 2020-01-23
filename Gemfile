source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in sorceress.gemspec
gemspec

gem 'pry', github: 'pry/pry'

ruby_version = Gem::Version.new(RUBY_VERSION)

gem 'rubocop_defaults', github: 'dvandersluis/rubocop_defaults', branch: ('experimental' if ruby_version >= Gem::Version.new('2.6'))
