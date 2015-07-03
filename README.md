# PR Log

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

## Features

- Plays nicely with existing hand written changelog content
- Fetches pull requests based on version milestone
- Detects pull requests already mentioned in the changelog
- Inserts links to GitHub pages of referenced pull requests
- Prefixes based on pull request labels ("Bug fix" etc.)
- Customizable entry template

## Installation

Install the command line tool:

    $ gem install pr_log

Generate a [personal access token]() and place it in a `.pr_log.yml`
file in your home directory:

    # ~/.pr_log.yml
    access_token: "xxx"

## Usage

To insert items for new pull requests with milestone `v.1.2` into your
`CHANGELOG.md` file run:

    $ prlog fetch --github-repository some/repository --milestone v1.2

By default, this creates entries of the form:

    - Title of the pull request
      ([#100](https://github.com/some/repository/pull/100)))

## Auto Detecting Configuration

The `fetch` command can also be invoked without command line options:

    $ prlog fetch

PrLog tries to derive defaults from gemspec information:

- If the `homepage` attribute mentions the URL of the github
  repository, it is used to determine the github repository name.
- PrLog constructs a milestone name of the form `v%{major}.%{minor}`
  from the current gem version.

## Configuration

To override PrLog's default configuration place a `.pr_log.yml` file
inside your project's root directory:

    # .pr_log.yml
    changelog_file: "HISTORY.md"
    insert_after: # HISTORY""

See the configuration object documentation for a complete list of
configuration options.

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake rspec` to run the tests. You can also
run `bin/console` for an interactive prompt that will allow you to
experiment. Run `bundle exec prlog` to use the gem in this directory,
ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tf/pr_log. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

