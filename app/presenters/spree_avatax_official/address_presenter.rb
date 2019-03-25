module SpreeAvataxOfficial
  class AddressPresenter
    def initialize(address:, address_type:)
      @address      = address
      @address_type = address_type
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/AddressLocationInfo/
    def to_json
      {
        address_type => serialized_address
      }
    end

    private

    attr_reader :address, :address_type

    def serialized_address
      address_type == 'ShipFrom' ? ship_from_address : ship_to_address
    end

    def ship_to_address
      SpreeAvataxOfficial::ShipToAddressPresenter.new(
        address: address
      ).to_json
    end

    def ship_from_address
      {
        line1:      address[:line1],
        line2:      address[:line2],
        city:       address[:city],
        region:     address[:region],
        country:    address[:country],
        postalCode: address[:postalCode]
      }
    end
  end
end
