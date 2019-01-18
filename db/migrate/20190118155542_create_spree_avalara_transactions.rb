class CreateSpreeAvalaraTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_avalara_transactions do |t|
      t.references :order, index: true
      t.references :reimbursement, index: true
      t.string :message

      t.timestamps
    end
  end
end
