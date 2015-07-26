module PrLog
  # Parse files from the local project directory
  class Project < Struct.new(:config)
    def issue_numbers_mentioned_in_changelog
      parsed_changelog.mentioned_issue_numbers
    end

    def milestone
      config.milestone || gemspec.version_milestone
    end

    def github_repository_name
      config.github_repository || gemspec.github_repository
    end

    def pull_requests_for_current_milestone
      github_repository.pull_requests_with_milestone(milestone)
    end

    private

    def github_repository
      GithubRepository.new(github_repository_name,
                           config.access_token)
    end

    def parsed_changelog
      ParsedChangelog.new(File.read(config.changelog_file),
                          github_repository: github_repository_name)
    end

    def gemspec
      Gemspec.new(Gem::Specification.load(Dir.glob('*.gemspec').first),
                  config.milestone_format)
    end
  end
end
