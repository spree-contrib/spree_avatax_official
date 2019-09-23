module SpreeAvataxOfficial
  module Transactions
    class PartialRefundPresenter < CreatePresenter
      OVERRIDE_TYPE   = 'TaxDate'.freeze
      OVERRIDE_REASON = 'Refund'.freeze

      def initialize(order:, refund_items:, transaction_code:)
        @order            = order
        @refund_items     = refund_items
        @transaction_code = transaction_code
        @transaction_type = SpreeAvataxOfficial::Transaction::RETURN_INVOICE
      end

      # based on https://developer.avalara.com/api-reference/avatax/rest/v2/models/CreateTransactionModel/
      # date should be refund date, taxDate should be order's completed_at date
      def to_json
        super.merge(
          date:        formatted_date(Time.current),
          taxOverride: tax_override
        )
      end

      private

      attr_reader :refund_items

      def tax_override
        {
          type:    self.class::OVERRIDE_TYPE,
          reason:  self.class::OVERRIDE_REASON,
          taxDate: formatted_date(order.completed_at)
        }
      end

      def items_payload
        refund_items.map do |item, (quantity, amount)|
          SpreeAvataxOfficial::ItemPresenter.new(
            item:            item,
            custom_quantity: quantity,
            custom_amount:   amount
          ).to_json
        end
      end
    end
  end
end
