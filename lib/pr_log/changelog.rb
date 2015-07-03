module PrLog
  # Get mentioned issues from a changelog
  class Changelog
    def initialize(text, options = {})
      @text = text
      @github_repository = options.fetch(:github_repository)
    end

    def mentioned_issue_numbers
      @text.scan(pull_request_urls_matcher).flatten.map(&:to_i)
    end

    private

    def pull_request_urls_matcher
      %r{#{repository_url_matcher}/pull/(\d+)}
    end

    def repository_url_matcher
      %r{https?://github.com/#{@github_repository}}
    end
  end
end
