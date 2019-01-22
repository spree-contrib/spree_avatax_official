module SpreeAvataxOfficial
  class Configuration < Spree::Preferences::Configuration
    preference :company_code, :string, default: ENV['AVATAX_COMPANY_CODE']
  end
end
