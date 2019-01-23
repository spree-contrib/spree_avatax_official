class CreateSpreeAvataxOfficialTransactions < SpreeExtension::Migration[4.2]
  def change
    create_table(:spree_avatax_official_transactions, id: false) do |t|
      t.integer    :id,                null: false, index: { unique: true }
      t.references :order,             null: false, index: true
      t.string     :transaction_type,  null: false, index: true
      t.timestamps
    end

    add_index(
      :spree_avatax_official_transactions,
      %i[transaction_type order_id],
      unique: true,
      name: 'index_transactions_on_transaction_type_and_order_id'
    )
  end
end
