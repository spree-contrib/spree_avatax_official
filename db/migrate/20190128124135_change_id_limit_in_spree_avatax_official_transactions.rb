class ChangeIdLimitInSpreeAvataxOfficialTransactions < SpreeExtension::Migration[4.2]
  def up
    change_column :spree_avatax_official_transactions, :id, :integer, limit: 8
  end

  def down
    change_column :spree_avatax_official_transactions, :id, :integer, limit: 4
  end
end
