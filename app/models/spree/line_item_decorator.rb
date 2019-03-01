module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def update_tax_charge
        return super unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::CreateTaxAdjustments.call(order: order)
      end
    end
  end
end

AVATAX_NAMESPACE::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
