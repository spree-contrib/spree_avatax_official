module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      AVATAX_CODE = 'FR'.freeze

      def avatax_number
        "#{id}-#{AVATAX_CODE}"
      end
    end
  end
end

Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
