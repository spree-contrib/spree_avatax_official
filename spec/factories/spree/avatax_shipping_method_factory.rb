FACTORY_BOT_CLASS.define do
  factory :avatax_shipping_method, class: Spree::ShippingMethod do
    zones      { [Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone, default_tax: true)] }
    name       { 'AvaTax Ground' }
    display_on { 'both' }

    transient do
      tax_included      { false }
      with_tax_category { true }
    end

    before(:create) do |shipping_method, evaluator|
      create(:country) if Spree::Country.count.zero?

      shipping_tax_rate              = create(:avatax_tax_rate, :shipping_tax_rate, included_in_price: evaluator.tax_included)
      shipping_method.tax_category   = shipping_tax_rate.tax_category if evaluator.with_tax_category
      shipping_method.calculator     = if Gem::Version.new(Spree.version) >= Gem::Version.new('2.3.0')
                                         build(:shipping_calculator, calculable: shipping_method, preferences: { currency: 'USD', amount: 10.0 })
                                       else
                                         build(:shipping_calculator, calculable: shipping_method)
                                       end

      if shipping_method.shipping_categories.empty?
        shipping_method.shipping_categories << (Spree::ShippingCategory.first || create(:shipping_category))
      end
    end

    if Gem::Version.new(Spree.version) < Gem::Version.new('2.3.0')
      after(:create) do |shipping_method|
        shipping_method.calculator.preferred_currency = 'USD'
        shipping_method.calculator.preferred_amount   = 10.0
      end
    end
  end
end
