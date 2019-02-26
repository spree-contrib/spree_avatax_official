module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def tax_category
        selected_shipping_rate.try(:tax_rate).try(:tax_category) || shipping_method.try(:tax_category)
      end
    end
  end
end

Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
