module SpreeAvataxOfficial
  module Transactions
    class ReturnItemPresenter
      def initialize(return_item:)
        @return_item = return_item
      end

      # based on https://developer.avalara.com/api-reference/avatax/rest/v2/models/RefundTransactionModel/
      def to_json
        {
          refundTransactionCode: transaction_code,
          referenceCode:         order.number,
          refundDate:            refund_date,
          refundType:            refund_type,
          refundLines:           refund_lines
        }
      end

      private

      attr_reader :return_item

      delegate :return_authorization, :inventory_unit, to: :return_item
      delegate :order,                                 to: :return_authorization
      delegate :inventory_units,                       to: :order, prefix: true

      def transaction_code
        order.avatax_sales_invoice_code
      end

      def refund_date
        order.completed_at.strftime('%Y-%m-%d')
      end

      def refund_type
        @refund_type ||= all_inventory_units_returned? ? 'Full' : 'Partial'
      end

      def refund_lines
        return unless refund_type == 'Partial'

        [inventory_unit.line_item.avatax_number]
      end

      def all_inventory_units_returned?
        order_inventory_units == [inventory_unit]
      end
    end
  end
end
