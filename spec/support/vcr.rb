VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }

  config.filter_sensitive_data('<AVATAX_TOKEN>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end
