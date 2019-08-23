module SpreeAvataxOfficial
  class ShipToAddressPresenter
    def initialize(address:)
      @address = address
    end

    def to_json # rubocop:disable Metrics/AbcSize
      {
        line1:      address.address1.try(:first, 50),
        line2:      address.address2.try(:first, 50),
        city:       address.city,
        region:     address.state.try(:abbr),
        country:    address.country.try(:iso),
        postalCode: address.zipcode
      }
    end

    private

    attr_reader :address
  end
end
