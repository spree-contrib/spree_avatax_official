class AddTaxCodeToSpreeTaxCategories < SpreeExtension::Migration[4.2]
  def change
    return if column_exists? :spree_tax_categories, :tax_code

    add_column :spree_tax_categories, :tax_code, :string
  end
end
