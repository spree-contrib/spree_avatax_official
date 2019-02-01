FACTORY_BOT_CLASS.define do
  factory :avatax_tax_rate, class: Spree::TaxRate do
    name               { 'Default AvaTax tax rate' }
    amount             { 0.0 }
    zone               { Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone) }
    show_rate_in_label { false }
    tax_category do
      Spree::TaxCategory.find_by(tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['Spree::LineItem']) ||
        create(:tax_category, tax_code: ::Spree::TaxCategory::DEFAULT_TAX_CODES['Spree::LineItem'])
    end

    association(:calculator, factory: :avatax_transaction_calculator)
  end
end
