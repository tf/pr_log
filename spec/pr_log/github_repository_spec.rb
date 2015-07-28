require 'spec_helper'

module PrLog
  describe GithubRepository, vcr: :once do
    include_context 'github fixture'

    describe '#pull_requests_with_milestone' do
      it 'raises NoPullRequestsForMilestone if no pull requests are found' do
        github_repository = GithubRepository.new(fixture_repository,
                                                 fixture_oauth_token)

        expect {
          github_repository.pull_requests_with_milestone('not-there')
        }.to raise_error(NoPullRequestsForMilestone)
      end

      it 'raises GithubRepositoryNotFound if repository not found' do
        github_repository = GithubRepository.new('tf/not-there',
                                                 fixture_oauth_token)

        expect {
          github_repository.pull_requests_with_milestone(fixture_milestone)
        }.to raise_error(GithubRepositoryNotFound)
      end
    end
  end
end
