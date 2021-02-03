# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'jekyll-indico'
  s.version     = '0.1.0'
  s.summary     = 'Read and/or cache indico meeting lists for Jekyll'
  s.authors     = ['Henry Schreiner']
  s.email       = 'henryfs@princeton.edu'
  s.homepage    = 'https://rubygems.org/gems/jekyll-indico'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.4.0'

  s.files       = ['lib/jekyll-indico.rb', 'lib/jekyll-indico/generator.rb']
  s.executables << 'jekyll-indico-cache'

  s.add_dependency "jekyll", ">= 3.8", "< 5.0"

  s.add_development_dependency "bundler", ">= 1.15"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rake'
end

