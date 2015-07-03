require 'vcr'

RSpec.configure do |config|
  config.around(:example, vcr: :once) do |example|
    VCR.use_cassette(example.metadata[:full_description], record: :once) do
      example.call
    end
  end
end
