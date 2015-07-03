require 'octokit'

module PrLog
  # Adapter for Github Api
  class GithubRepository
    def initialize(name, access_token)
      @name = name
      @client = Octokit::Client.new(access_token: access_token)
    end

    def pull_requests_with_milestone(milestone)
      get_issues("repo:#{@name} type:pr is:merged milestone:#{milestone}")
    end

    private

    def get_issues(query)
      @client.search_issues(query, per_page: 1000)['items'].map(&:to_hash)
    end
  end
end
