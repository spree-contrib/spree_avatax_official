require 'spree/testing_support/factories'

unless FACTORY_BOT_CLASS.factories.registered?(:canada_address)
  FACTORY_BOT_CLASS.define do
    factory :canada_address, class: Spree::Address do
      firstname         { FFaker::Name.first_name }
      lastname          { FFaker::Name.last_name }
      address1          { '298 Pinetree' }
      address2          { '' }
      city              { 'BEACONSFIELD' }
      zipcode           { 'H9W 5E1' }
      phone             { FFaker::PhoneNumberAU.mobile_phone_number }
      alternative_phone { FFaker::PhoneNumberAU.mobile_phone_number }
      state             { |address| Spree::State.where(name: 'Quebec', abbr: 'QC', country: address.country).first_or_create }

      country do
        canada_attributes = { name: 'Canada', iso_name: 'CANADA', iso: 'CA', iso3: 'CAN' }

        Spree::Country.find_by(canada_attributes) || create(:country, canada_attributes)
      end
    end
  end
end
