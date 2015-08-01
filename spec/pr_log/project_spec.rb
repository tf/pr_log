require 'spec_helper'

module PrLog
  describe Project, fixture_files: true do
    describe '#issue_numbers_mentioned_in_changelog' do
      it 'returns parsed issue numbers from changelog' do
        config = Configuration.new(changelog_file: 'HISTORY.md',
                                   github_repository: 'some/repo')
        project = Project.new(config)
        fixture_file('HISTORY.md', <<-TEXT)
          # CHANGELOG

          ## Unreleased Changes

          - PR already described here
          ([#1](https://github.com/some/repo/pull/1))
        TEXT

        result = project.issue_numbers_mentioned_in_changelog

        expect(result).to eq([1])
      end

      it 'raises ChangelogFileNotFound if changelog file is missing' do
        config = Configuration.new(changelog_file: 'HISTORY.md',
                                   github_repository: 'some/repo')
        project = Project.new(config)

        expect {
          project.issue_numbers_mentioned_in_changelog
        }.to raise_error(ChangelogFileNotFound)
      end
    end

    describe '#milestone' do
      it 'raises GemspecNotFound if gemspec file is missing' do
        config = Configuration.new(github_repository: 'some/repo')
        project = Project.new(config)

        expect {
          project.milestone
        }.to raise_error(GemspecNotFound)
      end
    end

    describe '#github_repository_name' do
      context 'without github repository config option' do
        it 'raises GithubRepositoryRequired if gemspec is missing' do
          config = Configuration.new
          project = Project.new(config)
          fixture_gemspec('test-gem.gemspec',
                          homepage_url: 'http://example.com')

          expect {
            project.github_repository_name
          }.to raise_error(GithubRepositoryRequired)
        end

        it 'raises descriptive error if gemspec uses non github homepage' do
          config = Configuration.new
          project = Project.new(config)

          expect {
            project.github_repository_name
          }.to raise_error(GithubRepositoryRequired)
        end
      end
    end
  end
end
