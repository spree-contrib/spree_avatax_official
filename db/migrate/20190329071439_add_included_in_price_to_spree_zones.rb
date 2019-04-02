class AddIncludedInPriceToSpreeZones < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_zones, :included_in_price, :boolean, default: false
  end
end
