require 'thor'

module PrLog
  # The main command line interface
  class Cli < Thor
    desc 'fetch', 'Insert changelog entries for new pull requests'
    method_option(:changelog_file,
                  aliases: '-c',
                  desc: 'Path of the changelog file')
    method_option(:insert_after,
                  aliases: '-i',
                  desc: 'Line to insert new entries after')
    method_option(:github_repository,
                  aliases: '-r',
                  desc: 'GitHub repository name')
    method_option(:access_token,
                  aliases: '-t',
                  desc: 'OAuth access token for GitHub API')
    method_option(:milestone,
                  aliases: '-m',
                  desc: 'Version milestone to filter pull requests')
    method_option(:milestone_format,
                  desc: 'Pattern to derive milestone from gem version')
    def fetch
      FetchCommand.perform(options) do |command|
        command.on(:fetching) do |milestone, github_repository_name|
          say_fetching(milestone, github_repository_name)
        end

        command.on(:inserting) do |pull_requests, changelog_file|
          say_inserting(pull_requests, changelog_file)
        end
      end
    rescue Error => e
      say_status(:error, e.message, :red)
    end

    private

    def say_fetching(milestone, github_repository_name)
      say_status(:fetching,
                 "pull requests for milestone #{milestone} " \
                 "from #{github_repository_name}")
    end

    def say_inserting(pull_requests, changelog_file)
      say_status(:inserting,
                 "#{pull_requests.size} entries into #{changelog_file}")
    end
  end
end
