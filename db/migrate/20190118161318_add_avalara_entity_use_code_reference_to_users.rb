class AddAvalaraEntityUseCodeReferenceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_users, :avalara_entity_use_code, index: true
  end
end
