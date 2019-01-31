module SpreeAvataxOfficial
  module Transactions
    class RefundPresenter
      def initialize(return_authorization:)
        @return_authorization = return_authorization
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

      attr_reader :return_authorization

      delegate :order, to: :return_authorization

      def transaction_code
        # TODO replace it with order.avatax_sales_invoice_transaction&.code
        # when OrderDecorator is merged
        SpreeAvataxOfficial::Transaction.find_by(
          order: order,
          transaction_type: SpreeAvataxOfficial::Transaction::SALES_INVOICE
        )&.code
      end

      def refund_date
        Time.current.strftime('%Y-%m-%d')
      end

      def refund_type
        @refund_type ||= all_inventory_units_returned? ? 'Full' : 'Partial'
      end

      def refund_lines
        order
          .line_items
          .where(id: line_item_ids)
          .map(&method(:line_item_json))
      end

      def line_item_ids
        return_authorization.inventory_units.pluck(:line_item_id).uniq
      end

      def line_item_json(line_item)
        SpreeAvataxOfficial::LineItemPresenter.new(line_item: line_item).to_json
      end

      def all_inventory_units_returned?
        return_authorization.inventory_units == order.inventory_units
      end
    end
  end
end
