FactoryBot.define do
  factory :avatax_tax_category, class: Spree::TaxCategory do
    name        { 'Tax category name' }
    description { 'Tax category description' }

    trait :clothing do
      name       { 'Clothing' }
      tax_code   { ::Spree::TaxCategory::DEFAULT_TAX_CODES['LineItem'] }
      is_default { true }
    end

    trait :shipping do
      name     { 'Shipping' }
      tax_code { ::Spree::TaxCategory::DEFAULT_TAX_CODES['Shipment'] }
    end
  end
end
