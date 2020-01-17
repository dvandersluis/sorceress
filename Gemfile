source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in sorceress.gemspec
gemspec

gem 'pry'

ruby_version = Gem::Version.new(RUBY_VERSION)
if ruby_version >= Gem::Version.new('2.6')
  gem 'rubocop_defaults', github: 'dvandersluis/rubocop_defaults', branch: 'experimental'
else
  gem 'rubocop_defaults', github: 'dvandersluis/rubocop_defaults'
end
