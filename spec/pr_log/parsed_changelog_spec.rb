require 'spec_helper'

module PrLog
  describe ParsedChangelog do
    describe '#mentioned_issue_numbers' do
      it 'returns array of issue numbers as strings' do
        changelog = ParsedChangelog.new(<<-TEXT.unindent, github_repository: 'some/repo')
          # CHANGELOG

          ## Unreleased Changes

          - PR already described here
          ([#1](https://github.com/some/repo/pull/1))
          - PR already described here
          ([#2](http://github.com/some/repo/pull/2))
        TEXT

        result = changelog.mentioned_issue_numbers

        expect(result).to eq([1, 2])
      end

      it 'ignores mentioned prs of other repositories' do
        changelog = ParsedChangelog.new(<<-TEXT.unindent, github_repository: 'some/repo')
          # CHANGELOG

          ## Unreleased Changes

          - PR already described here
          ([#1](https://github.com/other/repo/pull/1))
        TEXT

        result = changelog.mentioned_issue_numbers

        expect(result).to eq([])
      end
    end
  end
end
