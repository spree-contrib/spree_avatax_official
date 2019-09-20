require 'spree/testing_support/factories'

unless FACTORY_BOT_CLASS.factories.registered?(:europe_address)
  FACTORY_BOT_CLASS.define do
    factory :europe_address, class: Spree::Address do
      firstname         { FFaker::Name.first_name }
      lastname          { FFaker::Name.last_name }
      address1          { '10 Paternoster Sq' }
      address2          { '' }
      city              { 'London' }
      zipcode           { 'EC4M 7LS' }
      phone             { FFaker::PhoneNumberAU.mobile_phone_number }
      alternative_phone { FFaker::PhoneNumberAU.mobile_phone_number }

      country do
        uk_attributes = { name: 'United Kingdom', iso_name: 'UNITED KINGDOM', iso: 'GB', iso3: 'GBR' }

        Spree::Country.find_by(uk_attributes) || create(:country, uk_attributes)
      end
    end
  end
end
