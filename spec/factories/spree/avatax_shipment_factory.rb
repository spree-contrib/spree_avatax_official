FactoryBot.define do
  factory :avatax_shipment, class: Spree::Shipment do
    tracking { 'U10000' }
    cost     { 100.00 }
    state    { 'pending' }
    order
    stock_location

    before(:create) do |shipment|
      uuid = '6a9efefa-0c6c-4e63-ab43-f43f1d7b2e22'

      shipment.avatax_uuid = uuid if Spree::Shipment.find_by(avatax_uuid: uuid).nil?
    end

    after(:create) do |shipment|
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
