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
  end
end
