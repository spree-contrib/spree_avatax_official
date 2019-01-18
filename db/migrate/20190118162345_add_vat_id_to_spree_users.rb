class AddVatIdToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :vat_id, :string
  end
end
