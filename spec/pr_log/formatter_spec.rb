require 'spec_helper'

module PrLog
  describe Formatter do
    describe '#entries' do
      it 'interpolates entry templates with pull request data' do
        data = [{ title: 'Feature 1', number: 1 },
                { title: 'Feature 2', number: 2 }]
        template = "- %{title} (#%{number})\n"
        formatter = Formatter.new(data, template, {})

        result = formatter.entries

        expect(result).to eq(<<-TEXT.unindent)

          - Feature 1 (#1)
          - Feature 2 (#2)
        TEXT
      end

      it 'interpolates prefixes based on pull request labels' do
        data = [{ title: 'Some fix',
                  number: 1,
                  labels: [{ name: 'bug' }] }]
        template = "- %{title} (#%{number})\n"
        formatter = Formatter.new(data, template, 'bug' => 'Bug fix:')

        result = formatter.entries

        expect(result).to eq(<<-TEXT.unindent)

          - Bug fix: Some fix (#1)
        TEXT
      end

      it 'returns empty string if no pull requests are passed' do
        template = "- %{title} (#%{number})\n"
        formatter = Formatter.new([], template, {})

        result = formatter.entries

        expect(result).to eq('')
      end
    end
  end
end
