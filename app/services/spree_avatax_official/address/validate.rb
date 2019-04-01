module SpreeAvataxOfficial
  module Address
    class Validate < SpreeAvataxOfficial::Base
      def call(address:)
        response = send_request(address)

        return failure(response) if response['messages']

        success(response)
      end

      private

      def send_request(address)
        ship_to_address_model = SpreeAvataxOfficial::ShipToAddressPresenter.new(
          address: address
        ).to_json

        client.resolve_address(ship_to_address_model)
      end
    end
  end
end
