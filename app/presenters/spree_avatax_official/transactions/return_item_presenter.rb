module SpreeAvataxOfficial
  module Transactions
    class ReturnItemPresenter
      def initialize(return_item:)
        @return_item = return_item
      end

      # based on https://developer.avalara.com/api-reference/avatax/rest/v2/models/RefundTransactionModel/
      def to_json
        {}.tap do |params|
          params[:refundTransactionCode] = transaction_code
          params[:referenceCode]         = order.number
          params[:refundDate]            = refund_date
          params[:refundType]            = refund_type
          params[:refundLines]           = refund_lines if refund_type == 'Partial'
        end
      end

      private

      attr_reader :return_item

      delegate :return_authorization, :inventory_unit, to: :return_item
      delegate :order,                                 to: :return_authorization
      delegate :inventory_units,                       to: :order, prefix: true

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
        [inventory_unit.line_item.sku]
      end

      def all_inventory_units_returned?
        [inventory_unit] == order_inventory_units
      end
    end
  end
end
