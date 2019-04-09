module SpreeAvataxOfficial
  class Configuration < ::Spree::Preferences::Configuration
    preference :address_validation_enabled, :boolean, default: false
    preference :company_code,               :string,  default: ''
    preference :enabled,                    :boolean, default: false
    preference :ship_from_address,          :hash,    default: {}
    preference :log,                        :boolean, default: true
    preference :log_to_stdout,              :boolean, default: false
    preference :log_file_name,              :string,  default: 'avatax.log'
    preference :log_frequency,              :string,  default: 'weekly'
    preference :max_retries,                :integer, default: 2
    preference :open_timeout,               :decimal, default: 2.0
    preference :read_timeout,               :decimal, default: 6.0
    preference :show_rate_in_label,         :boolean, default: false
  end
end
