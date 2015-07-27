require 'octokit'

module PrLog
  # Adapter for Github Api
  class GithubRepository
    def initialize(name, access_token)
      @name = name
      @client = Octokit::Client.new(access_token: access_token)
    end

    def pull_requests_with_milestone(milestone)
      fail_if_empty(get_issues(milestone_query(milestone)))
    end

    private

    def milestone_query(milestone)
      "repo:#{@name} type:pr is:merged milestone:#{milestone}"
    end

    def fail_if_empty(result)
      return result if result.any?

      fail(NoPullRequestsForMilestone,
           'No pull requests for milestone')
    end

    def get_issues(query)
      @client.search_issues(query, per_page: 1000)['items'].map(&:to_hash)
    end
  end
end
