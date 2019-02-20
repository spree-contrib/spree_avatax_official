module SpreeAvataxOfficial
  module Transactions
    class PartialRefundPresenter < CreatePresenter
      def initialize(order:, refund_items:)
        @order             = order
        @refund_items      = refund_items
        @ship_from_address = order.ship_address
        @transaction_type  = SpreeAvataxOfficial::Transaction::RETURN_INVOICE
      end

      def to_json
        super.merge!(referenceCode: order.number)
      end

      private

      attr_reader :refund_items

      def items_payload
        refund_items.map { |item, quantity| SpreeAvataxOfficial::ItemPresenter.new(item: item, quantity: quantity).to_json }
      end
    end
  end
end
