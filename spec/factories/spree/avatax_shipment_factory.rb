FACTORY_BOT_CLASS.define do
  factory :avatax_shipment, class: Spree::Shipment do
    tracking { 'U10000' }
    cost     { 100.00 }
    state    { 'pending' }
    order
    stock_location

    after(:create) do |shipment, _evalulator|
      Spree::TaxCategory.find_by(name: 'Shipping') || create(:avatax_tax_category, :shipping)
      shipping_method = Spree::ShippingMethod.find_by(name: 'AvaTax Ground') || create(:avatax_shipping_method)
      shipment.add_shipping_method(shipping_method, true)

      shipment.order.line_items.each do |line_item|
        line_item.quantity.times do
          shipment.inventory_units.create(
            order_id:     shipment.order_id,
            variant_id:   line_item.variant_id,
            line_item_id: line_item.id
          )
        end
      end
    end
  end
end
