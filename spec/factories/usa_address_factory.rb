require 'spree/testing_support/factories'

FACTORY_BOT_CLASS.define do
  factory :usa_address, class: Spree::Address do
    firstname FFaker::Name.first_name
    lastname FFaker::Name.last_name
    address1 '822 Reed St'
    address2 ''
    city 'Philadelphia'
    zipcode '19147'
    phone FFaker::PhoneNumberAU.mobile_phone_number
    alternative_phone FFaker::PhoneNumberAU.mobile_phone_number
    state { |address| Spree::State.where(name: 'Pennsylvania', abbr: 'PA', country: address.country).first_or_create }
    country do
      usa_attributes = { name: 'United States', iso_name: 'UNITED STATES', iso: 'US', iso3: 'USA' }
      Spree::Country.find_by(usa_attributes) || create(:country, usa_attributes)
    end
  end
end unless FACTORY_BOT_CLASS.factories.registered?(:usa_address)
