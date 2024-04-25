require 'vcr'
require 'webmock/rspec'
require 'uri'
require 'webdrivers'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir                    = 'spec/vcr'
  config.ignore_localhost                        = true
  config.default_cassette_options                = { record: :new_episodes }

  config.configure_rspec_metadata!
  config.hook_into :webmock

  # webdrivers fix
  driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  driver_hosts << 'googlechromelabs.github.io'
  driver_hosts << 'edgedl.me.gvt1.com'
  driver_hosts << 'storage.googleapis.com'

  config.ignore_hosts(*driver_hosts)

  config.filter_sensitive_data('<AVATAX_TOKEN>') do |interaction|
    interaction.request.headers['Authorization'].first
  end

  config.filter_sensitive_data('AVATAX_USERNAME') do |interaction|
    JSON(interaction.response.body)['authenticatedUserName']
  end
end
