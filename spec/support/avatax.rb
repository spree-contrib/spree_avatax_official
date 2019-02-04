AvaTax.configure do |config|
  config.endpoint = 'https://sandbox-rest.avatax.com'
end

# Avatax API endpoints use this value as url parameter, thus it's required for VCR cassetes
SpreeAvataxOfficial::Config.company_code = 'test1'
