require 'spec_helper'

module PrLog
  describe Command do
    describe '.perform' do
      it 'provides event emitter functionality' do
        command = Class.new(Command) do
          def perform
            emit(:some, 'data')
          end
        end

        expect { |probe|
          command.perform({}) do |c|
            c.on(:some, &probe)
          end
        }.to yield_control
      end

      it 'fails if perform is not implemented' do
        command = Class.new(Command) do
        end

        expect {
          command.perform(changelog_file: 'History.md')
        }.to raise_error(NotImplementedError)
      end

      it 'provides config to command subclass' do
        command = Class.new(Command) do
          def perform
            config.changelog_file
          end
        end

        result = command.perform(changelog_file: 'History.md')

        expect(result).to eq('History.md')
      end
      
      it 'provides project to command subclass' do
        command = Class.new(Command) do
          def perform
            project
          end
        end

        result = command.perform(changelog_file: 'History.md')

        expect(result).to be_kind_of(Project)
      end
    end
  end
end
