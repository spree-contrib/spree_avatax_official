AvaTax.configure do |config|
  config.endpoint = 'https://sandbox-rest.avatax.com'
end

SpreeAvataxOfficial::Config.enabled           = false
SpreeAvataxOfficial::Config.company_code      = 'test1' # Avatax API endpoints use this value as url parameter, thus it's required for VCR cassetes
SpreeAvataxOfficial::Config.ship_from_address = {
  line1:      '822 Reed St',
  line2:      '',
  city:       'Philadelphia',
  region:     'PA',
  country:    'USA',
  postalCode: '19147'
}
