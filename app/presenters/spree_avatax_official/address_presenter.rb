module SpreeAvataxOfficial
  class AddressPresenter
    def initialize(address:, address_type:)
      @address      = address
      @address_type = address_type
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/AddressLocationInfo/
    def to_json
      {
        address_type => {
          line1:      address.address1,
          line2:      address.address2,
          city:       address.city,
          region:     address.state&.abbr,
          country:    address.country&.iso,
          postalCode: address.zipcode
        }
      }
    end

    private

    attr_reader :address, :address_type
  end
end
