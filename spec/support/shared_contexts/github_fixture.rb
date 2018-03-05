RSpec.shared_context 'github fixture' do
  let(:fixture_oauth_token) do
    ENV.fetch('PR_LOG_FIXTURE_OAUTH_TOKEN') do
      raise('Environment variable PR_LOG_FIXTURE_OAUTH_TOKEN must be defined.')
    end
  end

  let(:fixture_repository) do
    ENV.fetch('PR_LOG_FIXTURE_REPOSITORY', 'tf/pr_log_test_fixture')
  end

  let(:fixture_milestone) do
    'v1.1'
  end
end
