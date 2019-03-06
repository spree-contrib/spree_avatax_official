module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def tax_category
        selected_shipping_rate.try(:tax_rate).try(:tax_category) || shipping_method.try(:tax_category)
      end

      def avatax_tax_code
        tax_category.try(:tax_code).presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['Shipment']
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
