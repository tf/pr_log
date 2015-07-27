require 'spec_helper'

RSpec.describe('fetching new changelog entries',
               cli: true,
               vcr: :once,
               fixture_files: true) do

  include_context 'github fixture'

  let(:fixture_version) do
    '1.1.0'
  end

  let(:fixture_milestone) do
    'v1.1'
  end

  it 'takes configuration via command line' do
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           github_repository: fixture_repository,
           milestone: fixture_milestone,
           insert_after: "## Unreleased Changes\n")

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - Add a file to the repository
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT
  end

  it 'derives version milestone from gemspec version by default' do
    fixture_gemspec('test-gem.gemspec', version: fixture_version)
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           github_repository: fixture_repository,
           insert_after: "## Unreleased Changes\n")

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - Add a file to the repository
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT
  end

  it 'applies custom milestone format to version from gemspec', focus: true do
    fixture_gemspec('test-gem.gemspec', version: fixture_version)
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           github_repository: fixture_repository,
           insert_after: "## Unreleased Changes\n",
           milestone_format: 'v%{major}.%{minor}.%{patch}')

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - Add another file to the repository
        ([#2](https://github.com/#{fixture_repository}/pull/2))
    TEXT
  end

  it 'derives github repository from gemspec homepage' do
    gemspec_homepage = "https://github.com/#{fixture_repository}"
    fixture_gemspec('test-gem.gemspec', homepage: gemspec_homepage)
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           milestone: fixture_milestone,
           insert_after: "## Unreleased Changes\n")

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - Add a file to the repository
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT
  end

  it 'takes configuration from .pr_log.yml file in current directory' do
    fixture_file('.pr_log.yml', <<-TEXT)
      changelog_file: 'History.md'
      github_repository: '#{fixture_repository}'
      insert_after: "## Unreleased Changes\\n"
    TEXT
    changelog = fixture_file('History.md', <<-TEXT)
      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           milestone: fixture_milestone)

    expect(changelog.read).to eq(<<-TEXT.unindent)
      ## Unreleased Changes

      - Add a file to the repository
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT
  end

  it 'does not insert items for pull requests already mentioned in the changelog' do
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes

      - PR already described here
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           github_repository: fixture_repository,
           milestone: fixture_milestone,
           insert_after: "## Unreleased Changes\n")

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - PR already described here
        ([#1](https://github.com/#{fixture_repository}/pull/1))
    TEXT
  end

  it 'supports prefixing items based on issue labels' do
    label_prefixes = { 'bug' => 'Bug fix:' }
    changelog = fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG

      ## Unreleased Changes
    TEXT

    pr_log(:fetch,
           access_token: fixture_oauth_token,
           github_repository: fixture_repository,
           milestone: 'v1.1.1',
           insert_after: "## Unreleased Changes\n",
           label_prefixes: label_prefixes)

    expect(changelog.read).to eq(<<-TEXT.unindent)
      # CHANGELOG

      ## Unreleased Changes

      - Bug fix: Fix bug in file
        ([#3](https://github.com/#{fixture_repository}/pull/3))
    TEXT
  end

  it 'fails with helpful message if insertion point is not found' do
    fixture_file('CHANGELOG.md', <<-TEXT)
      # CHANGELOG
    TEXT

    expect {
      pr_log(:fetch,
             quiet: false,
             access_token: fixture_oauth_token,
             github_repository: fixture_repository,
             milestone: 'v1.1.1',
             insert_after: "## Not there\n")
    }.to output(/Insert point not found in CHANGELOG.md/).to_stdout
  end
end
