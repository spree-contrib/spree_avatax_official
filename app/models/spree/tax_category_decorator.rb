module SpreeAvataxOfficial
  module Spree
    module TaxCategoryDecorator
      DEFAULT_TAX_CODES = {
        'Spree::LineItem' => 'P0000000',
        'Spree::Shipment' => 'FR'
      }.freeze
    end
  end
end

Spree::TaxCategory.prepend ::SpreeAvataxOfficial::Spree::TaxCategoryDecorator
