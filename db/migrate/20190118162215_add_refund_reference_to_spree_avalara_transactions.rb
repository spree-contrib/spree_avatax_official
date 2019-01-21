class AddRefundReferenceToSpreeAvalaraTransactions < ActiveRecord::Migration[5.2]
  def change
    return if column_exists?(:spree_avalara_transactions, :refund_id)

    add_reference :spree_avalara_transactions, :refund, index: true
  end
end
