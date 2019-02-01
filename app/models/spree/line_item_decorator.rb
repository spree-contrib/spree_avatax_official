module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      AVATAX_CODE = 'LI'.freeze

      def avatax_number
        "#{id}-#{AVATAX_CODE}"
      end

      def update_tax_charge
        return super unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::CreateTaxAdjustments.call(order: order)
      end
    end
  end
end

Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
