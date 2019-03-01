class AddUuidToLineItemsAndShipments < SpreeExtension::Migration[4.2]
  def change
    table_prefix     = AVATAX_NAMESPACE.to_s.downcase
    line_items_table = table_prefix + '_line_items'
    shipments_table  = table_prefix + '_shipments'

    add_column(line_items_table, :avatax_uuid, :string, index: { unique: true }) unless column_exists?(line_items_table, :avatax_uuid)
    add_column(shipments_table, :avatax_uuid, :string, index: { unique: true }) unless column_exists?(shipments_table, :avatax_uuid)
  end
end
