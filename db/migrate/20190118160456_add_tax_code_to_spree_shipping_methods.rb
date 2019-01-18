class AddTaxCodeToSpreeShippingMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipping_methods, :tax_code, :string
  end
end
