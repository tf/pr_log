module Support
  module CliHelper
    def pr_log(command, options)
      cli = PrLog::Cli.new([], { quiet: true }.merge(options))
      cli.invoke(command)
    end
  end
end

RSpec.configure do |config|
  config.include(Support::CliHelper, cli: true)
end
