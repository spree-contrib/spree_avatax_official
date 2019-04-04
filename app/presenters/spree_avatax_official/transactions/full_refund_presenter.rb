module SpreeAvataxOfficial
  module Transactions
    class FullRefundPresenter
      def initialize(order:, transaction_code:)
        @order            = order
        @transaction_code = transaction_code
      end

      # based on https://developer.avalara.com/api-reference/avatax/rest/v2/models/RefundTransactionModel/
      def to_json
        {
          refundTransactionCode: transaction_code,
          referenceCode:         reference_code,
          refundDate:            refund_date,
          refundType:            'Full'
        }
      end

      private

      attr_reader :order, :transaction_code

      def reference_code
        order.number
      end

      def refund_date
        order.completed_at.strftime('%Y-%m-%d')
      end
    end
  end
end
