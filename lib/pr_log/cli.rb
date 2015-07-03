require 'thor'

module PrLog
  # The main command line interface
  class Cli < Thor
    include Thor::Actions

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
      config = Configuration.setup(options)
      project = Project.new(config)

      say_status(:fetching,
                 "pull requests for milestone #{project.milestone}" \
                 "from #{project.github_repository_name}")

      insert_into_file(config.changelog_file, after: config.insert_after) do
        project.new_changelog_entries
      end
    end
  end
end
