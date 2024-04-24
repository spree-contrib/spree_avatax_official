FACTORY_BOT_CLASS.define do
  factory :avatax_order, class: Spree::Order do
    user
    bill_address
    ship_address { create(:usa_address) }
    completed_at { nil }
    email        { user.email }
    state        { 'cart' }
    currency     { 'USD' }
    store        { Spree::Store.first || create(:store) }

    transient do
      line_items_price           { 10.0 }
      line_items_count           { 0 }
      line_items_quantity        { 1 }
      with_shipment              { false }
      with_shipping_tax_category { true }
      shipment_cost              { 5.0 }
      tax_category               { Spree::TaxCategory.find_by(name: 'Clothing') }
    end

    before(:create) do |_order, evaluator|
      Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone)
      Spree::TaxCategory.find_by(name: 'Clothing') || create(:avatax_tax_category, :clothing)
      Spree::TaxCategory.find_by(name: 'Shipping') || create(:avatax_tax_category, :shipping)
      Spree::ShippingMethod.find_by(name: 'AvaTax Ground') || create(:avatax_shipping_method, with_tax_category: evaluator.with_shipping_tax_category)
    end

    after(:create) do |order, evaluator|
      evaluator.line_items_count.times do
        create(
          :line_item,
          price:        evaluator.line_items_price,
          tax_category: evaluator.tax_category || Spree::TaxCategory.find_by(name: 'Clothing'),
          quantity:     evaluator.line_items_quantity,
          order:        order
        )
      end
      order.line_items.reload

      if evaluator.with_shipment
        create(:avatax_shipment, order: order, cost: evaluator.shipment_cost)
        order.shipments.reload
      end

      order.updater.update
    end

    trait :shipped do
      after(:create) do |order|
        create(:line_item, order: order)
        create(:avatax_shipment, order: order, state: :shipped)

        order.inventory_units.update_all(state: :shipped)
        order.update(ship_address: create(:usa_address), completed_at: Time.current)
      end
    end

    trait :completed do
      shipment_state { 'shipped' }
      payment_state  { 'paid' }

      after(:create) do |order|
        order.update_column(:completed_at, Time.current)
        order.update_column(:state, 'complete')
        create(:payment, amount: order.total, order: order, state: 'completed')
        order.updater.update
      end
    end
  end
end
