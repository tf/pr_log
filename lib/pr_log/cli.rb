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
      config = Configuration.setup(options)
      project = Project.new(config)

      say_status(:fetching,
                 "pull requests for milestone #{project.milestone} " \
                 "from #{project.github_repository_name}")

      say_status(:inserting, "entries into #{config.changelog_file}")

      injector = Injector.new(config.changelog_file)
      injector.insert_after(config.insert_after, project.new_changelog_entries)
    rescue Error => e
      say_status(:error, e.message)
    end
  end
end
