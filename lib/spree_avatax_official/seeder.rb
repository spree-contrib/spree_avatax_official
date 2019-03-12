module SpreeAvataxOfficial
  class Seeder
    def seed!
      create_default_tax_category
      create_and_assign_shipping_tax_category
    end

    private

    def create_default_tax_category
      ::Spree::TaxCategory.find_or_create_by!(name: 'Clothing')
                          .update!(tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['LineItem'], is_default: true)
    end

    def create_and_assign_shipping_tax_category
      shipping_tax_category = ::Spree::TaxCategory.find_or_create_by!(name: 'Shipping')
      shipping_tax_category.update!(tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['Shipment'])

      ::Spree::ShippingMethod.update_all(tax_category_id: shipping_tax_category.id)
    end
  end
end
