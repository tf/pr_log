require 'unindent'

module Support
  module FixtureFilesHelper
    DEFAULT_GEMSPEC_OPTIONS = {
      version: '0.0.1',
      homepage: 'http://example.com'
    }

    def fixture_file(path, contents)
      File.write(path, contents.unindent)
      Pathname.new(path)
    end

    def fixture_gemspec(path, options)
      fixture_path = File.expand_path('../../fixtures/gemspec', __FILE__)
      contents = File.read(fixture_path)
      contents = contents % DEFAULT_GEMSPEC_OPTIONS.merge(options)
      fixture_file(path, contents)
    end
  end
end

RSpec.configure do |config|
  config.include(Support::FixtureFilesHelper, fixture_files: true)

  config.around(:example, fixture_files: true) do |example|
    Dir.mktmpdir('pr_log_spec') do |dir|
      Dir.chdir(dir) do
        example.call
      end
    end
  end

  config.before(:example, fixture_files: true) do
    Gem::Specification.reset
  end
end
