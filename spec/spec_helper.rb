require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pr_log'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each do |file|
  require(file)
end
