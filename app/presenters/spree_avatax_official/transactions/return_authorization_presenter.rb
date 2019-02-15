module SpreeAvataxOfficial
  module Transactions
    class ReturnAuthorizationPresenter
      def initialize(return_authorization:)
        @return_authorization = return_authorization
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

      attr_reader :return_authorization

      delegate :order, :inventory_units,      to: :return_authorization
      delegate :line_items, :inventory_units, to: :order, prefix: true

      def transaction_code
        order.avatax_sales_invoice_transaction&.code
      end

      def refund_date
        order.completed_at.strftime('%Y-%m-%d')
      end

      def refund_type
        @refund_type ||= all_inventory_units_returned? ? 'Full' : 'Partial'
      end

      def refund_lines
        return unless refund_type == 'Partial'

        order_line_items
          .where(id: line_item_ids)
          .map(&:avatax_number)
      end

      def line_item_ids
        inventory_units.pluck(:line_item_id).uniq
      end

      def all_inventory_units_returned?
        inventory_units == order_inventory_units
      end
    end
  end
end
