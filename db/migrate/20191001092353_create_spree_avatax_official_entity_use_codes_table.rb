class CreateSpreeAvataxOfficialEntityUseCodesTable < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_avatax_official_entity_use_codes do |t|
      t.string          :code, required: true
      t.string          :name, required: true

      t.text            :description

      t.timestamps
    end

    add_reference :spree_users, :spree_avatax_official_entity_use_codes, type: :integer, index: true
  end
end
