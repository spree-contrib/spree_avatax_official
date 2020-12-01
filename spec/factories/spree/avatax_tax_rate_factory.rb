FactoryBot.define do
  factory :avatax_tax_rate, class: Spree::TaxRate do
    name               { 'Default AvaTax tax rate' }
    amount             { 0.0 }
    zone               { Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone) }
    show_rate_in_label { false }
    tax_category do
      Spree::TaxCategory.find_by(tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['LineItem']) ||
        create(:avatax_tax_category, :clothing)
    end

    trait :shipping_tax_rate do
      tax_category do
        Spree::TaxCategory.find_by(tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['Shipment']) ||
          create(:avatax_tax_category, :shipping)
      end
    end

    before(:create) do |tax_rate|
      tax_rate.calculator = build(:avatax_transaction_calculator, calculable: tax_rate)
    end
  end
end
