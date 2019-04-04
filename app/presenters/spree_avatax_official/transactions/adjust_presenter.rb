module SpreeAvataxOfficial
  module Transactions
    class AdjustPresenter
      def initialize(order:, adjustment_reason:, adjustment_description:)
        @order                  = order
        @adjustment_reason      = adjustment_reason
        @adjustment_description = adjustment_description
      end

      # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/AdjustTransactionModel/
      def to_json
        {
          adjustmentReason:      adjustment_reason,
          adjustmentDescription: adjustment_description,
          newTransaction:        transaction_payload
        }
      end

      private

      attr_reader :order, :adjustment_reason, :adjustment_description

      def transaction_payload
        SpreeAvataxOfficial::Transactions::CreatePresenter.new(
          order:            order,
          transaction_type: SpreeAvataxOfficial::Transaction::SALES_INVOICE,
          transaction_code: order.number
        ).to_json
      end
    end
  end
end
