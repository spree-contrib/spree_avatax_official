class AddCodeToSpreeAvataxOfficialTransactions < SpreeExtension::Migration[4.2]
  def change
    change_column :spree_avatax_official_transactions, :id, :primary_key
    remove_index :spree_avatax_official_transactions, :id

    add_column :spree_avatax_official_transactions, :code, :string
    add_index :spree_avatax_official_transactions, :code, unique: true
  end
end
