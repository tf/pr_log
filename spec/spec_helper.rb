require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pr_log'

Dir[File.join(__dir__, 'support/**/*.rb')].each do |file|
  require(file)
end
