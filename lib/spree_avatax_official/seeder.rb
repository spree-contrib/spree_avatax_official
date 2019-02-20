module SpreeAvataxOfficial
  class Seeder
    def initialize
      @parsed_address = JSON.parse(spree_avatax_certified_preference)
    end

    # TODO: Create initial data like Tax Categories
    def seed!
      copy_ship_from_address
    end

    private

    attr_reader :parsed_address

    # Copy ShipFrom address from SpreeAvataxCertified preference
    def copy_ship_from_address
      return if parsed_address.blank?

      SpreeAvataxOfficial::Config.ship_from_address = map_to_new_format(parsed_address)
    end

    def spree_avatax_certified_preference
      ::Spree::Preference.find_by(key: 'spree/app_configuration/avatax_origin').try(:value) || '{}'
    end

    def map_to_new_format(parsed_address)
      state_abbr   = ::Spree::State.find_by(name: parsed_address['Region']).try(:abbr)
      country_iso3 = ::Spree::Country.find_by(name: parsed_address['Country']).try(:iso3)

      {
        line1:      parsed_address['Address1'],
        line2:      parsed_address['Address2'],
        city:       parsed_address['City'],
        region:     state_abbr,
        country:    country_iso3,
        postalCode: parsed_address['Zip5']
      }
    end
  end
end
