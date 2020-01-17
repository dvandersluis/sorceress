lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sorceress/version'

Gem::Specification.new do |spec|
  spec.name          = 'sorceress'
  spec.version       = Sorceress::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['daniel.vandersluis@gmail.com']

  spec.summary       = 'Extensible and configurable setup script'
  spec.homepage      = 'https://github.com/dvandersluis/sorceress'

  spec.metadata['allowed_push_host'] = 'https://www.rubygems.org'

  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/dvandersluis/sorceress/CHANGES.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'psych', '~> 3'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
