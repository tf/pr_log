require 'virtus'

module PrLog
  # Configuration options
  class Configuration
    include Virtus.model

    attribute :changelog_file, String, default: 'CHANGELOG.md'

    attribute :insert_after, Regexp, default: "# CHANGELOG\n"

    attribute :label_prefixes, Hash, default: { bug: 'Bug fix:' }

    attribute :github_repository, String

    attribute :access_token, String

    attribute :milestone, String

    attribute :milestone_format, String, default: 'v%{major}.%{minor}'

    attribute :entry_template, String, default: <<-TEXT.gsub(/^ {6}/, '')
      - %{title}
        ([#%{number}](%{html_url}))
    TEXT

    def set(attributes)
      self.attributes = attributes.reject do |_, value|
        value.nil?
      end
    end

    def set_from_files
      CONFIG_FILE_NAMES.each do |config_file_name|
        next unless File.exist?(config_file_name)
        self.attributes = YAML.load_file(config_file_name)
      end
    end

    def self.setup(attributes)
      config = new

      config.set_from_files
      config.set(attributes)

      config
    end

    CONFIG_FILE_NAMES = [
      "#{ENV['HOME']}/.pr_log.yml",
      '.pr_log.yml'
    ].freeze
  end
end
