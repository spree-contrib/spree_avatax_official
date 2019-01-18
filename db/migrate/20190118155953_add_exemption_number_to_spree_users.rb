class AddExemptionNumberToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :exemption_number, :string
  end
end
