# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-indico/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-indico'
  spec.version       = JekyllIndico::VERSION
  spec.authors       = ['Henry Schreiner']
  spec.email         = ['henryschreineriii@gmail.com']

  spec.summary       = 'Read and/or cache indico meeting lists for Jekyll'
  spec.homepage      = 'https://rubygems.org/gems/jekyll-indico'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/iris-hep/jekyll-indico'
    spec.metadata['changelog_uri'] = 'https://github.com/iris-hep/jekyll-indico/blob/main/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'jekyll', '>= 3.8', '< 5.0'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
