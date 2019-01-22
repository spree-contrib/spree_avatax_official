AvaTax.configure do |config|
  config.endpoint = ENV['AVATAX_ENDPOINT']
  config.username = ENV['AVATAX_USERNAME']
  config.password = ENV['AVATAX_PASSWORD']
end
