module SpreeAvataxOfficial
  class Configuration < Spree::Preferences::Configuration
    preference :company_code, :string, default: ENV['AVATAX_COMPANY_CODE']
    preference :enabled, :boolean, default: false
    preference :ship_from_address, :hash, default: {}
  end
end
