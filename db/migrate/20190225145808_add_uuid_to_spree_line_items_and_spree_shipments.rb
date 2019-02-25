class AddUuidToSpreeLineItemsAndSpreeShipments < SpreeExtension::Migration[4.2]
  def change
    add_column(:spree_line_items, :avatax_uuid, :string, index: { unique: true }) unless column_exists?(:spree_line_items, :avatax_uuid)
    add_column(:spree_shipments, :avatax_uuid, :string, index: { unique: true }) unless column_exists?(:spree_shipments, :avatax_uuid)
  end
end
