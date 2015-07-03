require 'spec_helper'

module PrLog
  describe Gemspec do
    describe '#version_milestone' do
      it 'uses version from parsed gemspec' do
        milestone_format = 'version-%{major}.%{minor}.%{patch}'
        specification = Gem::Specification.new('test', '2.0.1')
        gemspec = Gemspec.new(specification, milestone_format)

        expect(gemspec.version_milestone).to eq('version-2.0.1')
      end

      it 'removes version suffixes' do
        milestone_format = 'v%{major}.%{minor}'
        specification = Gem::Specification.new('test', '2.0.0.alpha')
        gemspec = Gemspec.new(specification, milestone_format)

        expect(gemspec.version_milestone).to eq('v2.0')
      end
    end

    describe '#github_repository', ttt: true do
      it 'extracts github repository name from github http url' do
        github_url = 'http://github.com/some/repo'
        specification = Gem::Specification.new { |s| s.homepage = github_url }
        gemspec = Gemspec.new(specification, '')

        result = gemspec.github_repository

        expect(result).to eq('some/repo')
      end

      it 'extracts github repository name from github https url' do
        github_url = 'https://github.com/some/repo'
        specification = Gem::Specification.new { |s| s.homepage = github_url }
        gemspec = Gemspec.new(specification, '')

        result = gemspec.github_repository

        expect(result).to eq('some/repo')
      end

      it 'returns nil if not a github url' do
        other_url = 'https://example.com'
        specification = Gem::Specification.new { |s| s.homepage = other_url }
        gemspec = Gemspec.new(specification, '')

        result = gemspec.github_repository

        expect(result).to eq(nil)
      end

      it 'returns nil if no gemspec exists' do
        gemspec = Gemspec.new(nil, '')

        result = gemspec.github_repository

        expect(result).to eq(nil)
      end
    end
  end
end
