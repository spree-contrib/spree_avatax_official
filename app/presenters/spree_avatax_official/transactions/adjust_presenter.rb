module SpreeAvataxOfficial
  module Transactions
    class AdjustPresenter
      def initialize(order:, ship_from_address:, adjustment_reason:)
        @order             = order
        @ship_from_address = ship_from_address
        @adjustment_reason = adjustment_reason
      end

      # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/AdjustTransactionModel/
      def to_json
        {
          adjustmentReason: adjustment_reason,
          newTransaction:   transaction_payload
        }
      end

      private

      attr_reader :order, :ship_from_address, :adjustment_reason

      def transaction_payload
        transaction = order.avatax_sales_invoice_transaction

        SpreeAvataxOfficial::Transactions::CreatePresenter.new(
          order:             order,
          ship_from_address: ship_from_address,
          transaction_type:  transaction.transaction_type,
          transaction_code:  transaction.code
        ).to_json
      end
    end
  end
end
