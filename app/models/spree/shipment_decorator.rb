module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      AVATAX_CODE = 'FR'.freeze

      def avatax_number
        "#{id}-#{AVATAX_CODE}"
      end

      def tax_category
        selected_shipping_rate.try(:tax_rate).try(:tax_category) || shipping_method.try(:tax_category)
      end
    end
  end
end

Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
