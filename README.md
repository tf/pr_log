# PR Log

[![Gem Version](https://badge.fury.io/rb/pr_log.svg)](http://badge.fury.io/rb/pr_log)
[![Dependency Status](https://gemnasium.com/tf/pr_log.svg)](https://gemnasium.com/tf/pr_log)
[![CI](https://github.com/tf/pr_log/actions/workflows/test.yml/badge.svg)](https://github.com/tf/pr_log/actions/workflows/test.yml)
[![Test Coverage](https://codeclimate.com/github/tf/pr_log/badges/coverage.svg)](https://codeclimate.com/github/tf/pr_log)
[![Code Climate](https://codeclimate.com/github/tf/pr_log/badges/gpa.svg)](https://codeclimate.com/github/tf/pr_log)

Turn GitHub pull requests into changelog entries.

## Assumptions

**Changelogs should be written for humans by humans**

PrLog does not try to auto generate a complete changelog. Instead, it
pulls GitHub data to prefill your changelog as a baseline for manual
editing. Add prose, order items by priority, insert headers.

**Merged pull requests fully describe project history**

PrLog ignores GitHub issues. If a pull request fixes an
important issue it can reference it in its title or description.

**Pull requests are tagged with version milestones**

PrLog expects pull requests to be assigned to version milestones like
`v1.1`. This ensures consistency with the issue tracker and helps
limit GitHub API requests to relevant data.

**Changelogs are written in Markdown**

Markdown is the de facto standard for formatting files to be
displayed on GitHub.

## Installation

Install the command line tool:

    $ gem install pr_log

Generate a
[personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
and place it in a `.pr_log.yml` file in your home directory:

    # ~/.pr_log.yml
    access_token: "xxx"

## Usage

To insert items for new pull requests with milestone `v.1.2` into your
`CHANGELOG.md` file run:

    $ prlog fetch --github-repository some/repository --milestone v1.2

By default, this creates entries of the form:

    - Title of the pull request
      ([#100](https://github.com/some/repository/pull/100)))

If a pull request URL is already mentioned in the changelog, no entry
will be created.

### Convention over Configuration

The `fetch` command can also be invoked without command line options:

    $ prlog fetch

PrLog tries to derive defaults from gemspec information:

- If the `homepage` attribute mentions the URL of the github
  repository, it is used to determine the github repository name.
- PrLog constructs a milestone name of the form `v%{major}.%{minor}`
  from the current gem version.

### Configuration

To override PrLog's default configuration you can either pass command
line options or place a `.pr_log.yml` file inside your project's root
or your home directory:

    # .pr_log.yml
    changelog_file: "HISTORY.md"

The following configuration options are available:

- `access_token`: Personal access token to use for GitHub API
  requests.

- `changelog_file`: Relative path to the changelog file.

- `entry_template`: Template string used for new changelog
  entries. All fields from the
  [issue search response](https://developer.github.com/v3/search/#search-issues)
  can be used as interpolations.
  Default value: `- %{title} ([#%{number}](%{html_url}))`. Use `.` for nested fields (e.g. `%{user.login}`).

- `github_repository`: Name of the GitHub repository of the form
  `user/repository`.

- `insert_after`: Regular expression or string matching the line
  inside the changelog after which new items shall be inserted.

- `label_prefixes`: A hash mapping GitHub label names to title
  prefixes for changelog entries. See below for details.

- `milestone`: Name of the milestone filter fetched pull requests by.

- `milestone_format`: Template string used to derive a milestone name
  from the current gem version. The strings `%{major}`, `%{minor}` and
  `%{patch}` are replaces with the corresponding numeric component of
  the current version. Default value: `v%{major}.%{minor}`.

### Label Prefixes

Items for pull requests with certain labels can be prefixed with a
string automatically. To add a "Bug fix:" prefix to all pull requests
with the label `bug`, add the following lines to your configuration file:

    # pr_log.yml
    label_prefixes:
      bug: "Bug fix:"

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.
You can then use `rake install` to install the gem locally.

### Running the Test Suite

The test suite uses [VCR](https://github.com/vcr/vcr) to record and
replay requests to the GitHub API. When running against the bundled VCR
cassettes, no GitHub credentials are required. If you run the tests
without VCR or re-record the cassettes, set the environment variable
`PR_LOG_FIXTURE_OAUTH_TOKEN` to a valid GitHub access token. Then run
`bin/rspec`. Fixture data used by the test suite comes from the
[tf/pr_log_test_fixture](https://github.com/tf/pr_log_test_fixture)
repository.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tf/pr_log. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

