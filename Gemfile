source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in sorceress.gemspec
gemspec

gem 'pry'

ruby_version = Gem::Version.new(RUBY_VERSION)
rubocop_defaults_opts = { github: 'dvandersluis/rubocop_defaults' }
rubocop_defaults_opts[:branch] = 'experimental' if ruby_version >= Gem::Version.new('2.6')

gem 'rubocop_defaults', rubocop_defaults_opts
