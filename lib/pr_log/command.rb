require 'events'

module PrLog
  # Event emitting command base class
  class Command
    include Events::Emitter

    pattr_initialize :config

    def self.perform(options)
      command = new(Configuration.setup(options))
      yield(command) if block_given?
      command.perform
    end

    def perform
      fail(NotImplementedError)
    end

    private

    def project
      @project ||= Project.new(config)
    end
  end
end
