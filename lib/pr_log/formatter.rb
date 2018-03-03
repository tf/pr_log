module PrLog
  # Format new pull requests from github search response
  class Formatter
    pattr_initialize :pull_requests, :entry_template, :label_prefixes

    def entries
      return '' if pull_requests.empty?

      pull_requests.map { |pull_request|
        entry_template % entry_template_data(pull_request)
      }.join.prepend("\n")
    end

    private

    def entry_template_data(pull_request)
      pull_request.merge(title: prefixed_title(pull_request))
    end

    def prefixed_title(pull_request)
      [label_prefix(pull_request),
       format_title(pull_request)].compact.join(' ')
    end

    def label_prefix(pull_request)
      pull_request.fetch(:labels, []).map { |label|
        label_prefixes[label[:name].to_s]
      }.compact.first
    end

    def format_title(pull_request)
      pull_request[:title]
    end
  end
end
