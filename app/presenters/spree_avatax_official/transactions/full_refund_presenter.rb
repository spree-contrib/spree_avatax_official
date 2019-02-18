module SpreeAvataxOfficial
  module Transactions
    class FullRefundPresenter
      def initialize(order:)
        @order = order
      end

      # based on https://developer.avalara.com/api-reference/avatax/rest/v2/models/RefundTransactionModel/
      def to_json
        {
          referenceCode: reference_code,
          refundDate:    refund_date,
          refundType:    'Full'
        }
      end

      private

      attr_reader :order

      def reference_code
        order.number
      end

      def refund_date
        order.completed_at.strftime('%Y-%m-%d')
      end
    end
  end
end
