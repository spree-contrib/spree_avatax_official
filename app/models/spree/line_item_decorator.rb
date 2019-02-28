module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def update_tax_charge
        return super unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::CreateTaxAdjustmentsService.call(order: order)
      end

      def avatax_tax_code
        tax_category&.tax_code.presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['Spree::LineItem']
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
