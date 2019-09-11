module SpreeAvataxOfficial
  module Spree
    module TaxCategoryDecorator
      def self.prepended(base)
        base.const_set 'DEFAULT_TAX_CODES', {
          'LineItem' => 'P0000000',
          'Shipment' => 'FR'
        }.freeze
      end
    end
  end
end

::Spree::TaxCategory.prepend ::SpreeAvataxOfficial::Spree::TaxCategoryDecorator
