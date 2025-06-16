RSpec.shared_context 'github fixture' do
  let(:fixture_oauth_token) do
    token = ENV.fetch('PR_LOG_FIXTURE_OAUTH_TOKEN', '<ACCESS_TOKEN>')
    if token == '<ACCESS_TOKEN>' && !VCR.turned_on?
      raise('Environment variable PR_LOG_FIXTURE_OAUTH_TOKEN must be defined when VCR is disabled.')
    end
    token
  end

  let(:fixture_repository) do
    ENV.fetch('PR_LOG_FIXTURE_REPOSITORY', 'tf/pr_log_test_fixture')
  end

  let(:fixture_milestone) do
    'v1.1'
  end
end
