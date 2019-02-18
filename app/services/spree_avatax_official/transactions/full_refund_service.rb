module SpreeAvataxOfficial
  module Transactions
    class FullRefundService < SpreeAvataxOfficial::Base
      def call(order:)
        create_refund(order).tap do |response|
          return request_result(response) do
            create_transaction!(
              code:             response['code'],
              order:            order,
              transaction_type: SpreeAvataxOfficial::Transaction::RETURN_INVOICE
            )
          end
        end
      end

      private

      def create_refund(order)
        client.refund_transaction(
          company_code,
          order.avatax_sales_invoice_code,
          refund_model(order)
        )
      end

      def refund_model(order)
        FullRefundPresenter.new(order: order).to_json
      end
    end
  end
end
