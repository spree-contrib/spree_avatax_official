module SpreeAvataxOfficial
  module Transactions
    class AdjustPresenter
      def initialize(order:, adjustment_reason:)
        @order             = order
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

      attr_reader :order, :adjustment_reason

      def transaction_payload
        SpreeAvataxOfficial::Transactions::CreatePresenter.new(
          order:            order,
          transaction_type: SpreeAvataxOfficial::Transaction::SALES_INVOICE,
          transaction_code: order.avatax_sales_invoice_code
        ).to_json
      end
    end
  end
end
