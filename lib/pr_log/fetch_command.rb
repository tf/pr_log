require 'pr_log/command'

module PrLog
  # Top level workflow of the fetch command
  class FetchCommand < Command
    def perform
      emit(:fetching, project.milestone, project.github_repository_name)
      pull_requests = new_pull_requests

      emit(:inserting, pull_requests, config.changelog_file)
      insert_pull_requests(pull_requests)
    end

    private

    def new_pull_requests
      pull_requests = project.pull_requests_for_current_milestone

      excluded_issue_numbers = project.issue_numbers_mentioned_in_changelog

      pull_requests.reject do |pull_request|
        excluded_issue_numbers.include?(pull_request[:number])
      end
    end

    def insert_pull_requests(pull_requests)
      entries = formatter(pull_requests).entries
      injector.insert_after(config.insert_after, entries)
    end

    def formatter(pull_requests)
      Formatter.new(pull_requests,
                    config.entry_template,
                    config.label_prefixes)
    end

    def injector
      Injector.new(config.changelog_file)
    end
  end
end
