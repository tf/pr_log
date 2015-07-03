module PrLog
  # Parse files from the local project directory
  class Project < Struct.new(:config)
    def new_changelog_entries
      pull_requests = pull_requests_for_current_milestone

      excluded_issue_numbers = issue_numbers_mentioned_in_changelog

      pull_requests.reject! do |pull_request|
        excluded_issue_numbers.include?(pull_request[:number])
      end

      formatter(pull_requests).entries
    end

    def issue_numbers_mentioned_in_changelog
      changelog.mentioned_issue_numbers
    end

    def milestone
      config.milestone || gemspec.version_milestone
    end

    def github_repository_name
      config.github_repository || gemspec.github_repository
    end

    private

    def pull_requests_for_current_milestone
      github_repository.pull_requests_with_milestone(milestone)
    end

    def formatter(pull_requests)
      Formatter.new(pull_requests,
                    config.entry_template,
                    config.label_prefixes)
    end

    def github_repository
      GithubRepository.new(github_repository_name,
                           config.access_token)
    end

    def changelog
      Changelog.new(File.read(config.changelog_file),
                    github_repository: github_repository_name)
    end

    def gemspec
      Gemspec.new(Gem::Specification.load(Dir.glob('*.gemspec').first),
                  config.milestone_format)
    end
  end
end
