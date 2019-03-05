FACTORY_BOT_CLASS.define do
  factory :avatax_shipping_method, class: Spree::ShippingMethod do
    zones      { [Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone, default_tax: true)] }
    name       { 'AvaTax Ground' }
    display_on { 'both' }
    association(:calculator, factory: :shipping_calculator, strategy: :create)

    transient do
      tax_included      { false }
      with_tax_category { true }
    end

    before(:create) do |shipping_method, evaluator|
      create(:country) if Spree::Country.count.zero?

      shipping_tax_rate            = create(:avatax_tax_rate, :shipping_tax_rate, included_in_price: evaluator.tax_included)
      shipping_method.tax_category = shipping_tax_rate.tax_category if evaluator.with_tax_category
      if shipping_method.shipping_categories.empty?
        shipping_method.shipping_categories << (Spree::ShippingCategory.first || create(:shipping_category))
      end
    end
  end
end
