require 'spec_helper'

module PrLog
  describe Injector, fixture_files: true do
    describe '#insert_after' do
      it 'insert text after given lines' do
        changelog = fixture_file('CHANGELOG.md', <<-TEXT)
          # CHANGELOG
        TEXT
        injector = Injector.new('CHANGELOG.md')

        injector.insert_after("# CHANGELOG\n", "- Some item\n")

        expect(changelog.read).to eq(<<-TEXT.unindent)
          # CHANGELOG
          - Some item
        TEXT
      end

      it 'raises error if insert after line is not found' do
        fixture_file('CHANGELOG.md', '')
        injector = Injector.new('CHANGELOG.md')

        expect {
          injector.insert_after("# Not there\n", "- Some item\n")
        }.to raise_error(InsertPointNotFound)
      end
    end
  end
end
