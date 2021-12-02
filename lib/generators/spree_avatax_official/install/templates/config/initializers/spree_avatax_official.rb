module SpreeAvataxOfficial
  Config = SpreeAvataxOfficial::Configuration.new
end

AvaTax.configure do |config|
  config.endpoint = 'https://sandbox-rest.avatax.com' # This endpoint is used for testing and should be replaced
  config.username = ''
  config.password = ''
end

# Fields necessary to enable AvaTax tax calculation
SpreeAvataxOfficial::Config.enabled            = false
SpreeAvataxOfficial::Config.company_code       = ''
SpreeAvataxOfficial::Config.ship_from_address  = {
  line1:      '', # 822 Reed St
  line2:      '',
  city:       '', # Philadelphia
  region:     '', # PA
  country:    '', # USA
  postalCode: ''  # 19147
}

# Optional configuration fields
SpreeAvataxOfficial::Config.address_validation_enabled = false
SpreeAvataxOfficial::Config.log                        = true
SpreeAvataxOfficial::Config.log_to_stdout              = false
SpreeAvataxOfficial::Config.log_file_name              = 'avatax.log'
SpreeAvataxOfficial::Config.log_frequency              = 'weekly'
SpreeAvataxOfficial::Config.max_retries                = 2
SpreeAvataxOfficial::Config.open_timeout               = 2.0
SpreeAvataxOfficial::Config.read_timeout               = 6.0
SpreeAvataxOfficial::Config.show_rate_in_label         = false
