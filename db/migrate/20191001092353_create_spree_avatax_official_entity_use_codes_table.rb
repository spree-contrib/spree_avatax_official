class CreateSpreeAvataxOfficialEntityUseCodesTable < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_avatax_official_entity_use_codes do |t|
      t.string          :code, index: true, required: true, unique: true
      t.string          :name, index: true, required: true, unique: true

      t.text            :description

      t.timestamps
    end

    return if column_exists?(:spree_users, :avatax_entity_use_code_id)

    change_table :spree_users do |t|
      t.integer :avatax_entity_use_code_id, index: { unique: true }, foreign_key: true
    end
  end
end
