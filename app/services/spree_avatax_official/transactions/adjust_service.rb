module SpreeAvataxOfficial
  module Transactions
    class AdjustService < SpreeAvataxOfficial::Base
      def call(order:, ship_from_address:, adjustment_reason:, options: {})
        response = send_request(order, ship_from_address, adjustment_reason, options)

        return failure(response) if response['error'].present?

        invoice_transaction = order.avatax_sales_invoice_transaction

        if invoice_transaction.present?
          invoice_transaction.update!(code: response['code'], transaction_type: response['type'])
        else
          SpreeAvataxOfficial::Transaction.create!(order: order, transaction_type: response['type'])
        end

        success(response)
      end

      private

      def send_request(order, ship_from_address, adjustment_reason, options)
        adjust_transaction_model = SpreeAvataxOfficial::Transactions::AdjustPresenter.new(
          order: order,
          ship_from_address: ship_from_address,
          adjustment_reason: adjustment_reason
        ).to_json

        client.adjust_transaction(
          company_code,
          order.avatax_sales_invoice_transaction.code,
          adjust_transaction_model,
          options
        )
      end
    end
  end
end
