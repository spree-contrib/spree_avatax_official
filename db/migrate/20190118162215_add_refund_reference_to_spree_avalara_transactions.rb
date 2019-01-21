class AddRefundReferenceToSpreeAvalaraTransactions < SpreeExtension::Migration[4.2]
  def change
    return if column_exists?(:spree_avalara_transactions, :refund_id)

    add_reference :spree_avalara_transactions, :refund, index: true
  end
end
