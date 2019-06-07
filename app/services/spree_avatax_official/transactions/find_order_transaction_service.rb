module SpreeAvataxOfficial
  module Transactions
    class FindOrderTransactionService < SpreeAvataxOfficial::Base
      def call(order:)
        return success(true)  if order.avatax_sales_invoice_transaction.present?
        return failure(false) if get_transaction(order).failure?

        order.create_avatax_sales_invoice_transaction(code: order.number)

        # ensure taxable items have avatax_uuid
        order.taxable_items.each { |item| item.update(avatax_uuid: SecureRandom.uuid) }

        success(true)
      end

      private

      def get_transaction(order)
        SpreeAvataxOfficial::Transactions::GetByCodeService.call(order: order)
      end
    end
  end
end
