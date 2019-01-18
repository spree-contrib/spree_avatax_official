class AddRefundReferenceToSpreeAvalaraTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_avalara_transactions, :refund, index: true
  end
end
