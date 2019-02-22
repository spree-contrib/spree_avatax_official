FACTORY_BOT_CLASS.define do
  factory :avatax_order, class: Spree::Order do
    user
    bill_address
    ship_address
    completed_at { nil }
    email        { user.email }
    state        { 'cart' }

    transient do
      line_items_price    { 10.0 }
      line_items_count    { 0 }
      line_items_quantity { 1 }
      with_shipment       { false }
      shipment_cost       { 5.0 }
      tax_category        { Spree::TaxCategory.find_by(name: 'Clothing') }
    end

    before(:create) do
      Spree::Zone.find_by(name: 'GlobalZone') || create(:avatax_global_zone)
      Spree::TaxCategory.find_by(name: 'Clothing') || create(:avatax_tax_category, :clothing)
      Spree::TaxCategory.find_by(name: 'Shipping') || create(:avatax_tax_category, :shipping)
      Spree::ShippingMethod.find_by(name: 'AvaTax Ground') || create(:avatax_shipping_method)
    end

    after(:create) do |order, evaluator|
      evaluator.line_items_count.times do |index|
        create(
          :line_item,
          id:           index + 1,
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
  end
end
