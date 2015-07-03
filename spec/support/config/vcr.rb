require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<ACCESS_TOKEN>') do
    ENV.fetch('PR_LOG_FIXTURE_OAUTH_TOKEN') do
      fail('Environment variable PR_LOG_FIXTURE_OAUTH_TOKEN must be defined.')
    end
  end
end
