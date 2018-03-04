# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pr_log/version'

Gem::Specification.new do |spec|
  spec.name = 'pr_log'
  spec.version = PrLog::VERSION
  spec.authors = ['Tim Fischbach']
  spec.email = ['mail@timfischbach.de']

  spec.summary = 'Turn GitHub pull requests into changelog entries'
  spec.homepage = 'https://github.com/tf/pr_log'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^spec/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'virtus', '~> 1.0'
  spec.add_dependency 'events', '~> 0.9.8'
  spec.add_dependency 'attr_extras', '~> 4.4'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'unindent', '~> 1.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop', '>= 0.47.0'
end
