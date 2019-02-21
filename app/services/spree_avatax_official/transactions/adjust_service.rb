module SpreeAvataxOfficial
  module Transactions
    class AdjustService < SpreeAvataxOfficial::Base
      def call(order:, adjustment_reason:, options: {}) # rubocop:disable Metrics/MethodLength
        response = send_request(order, adjustment_reason, options)

        request_result(response) do
          invoice_transaction = order.avatax_sales_invoice_transaction

          if invoice_transaction.present?
            invoice_transaction.update!(code: response['code'], transaction_type: response['type'])
          else
            create_transaction!(
              code:             response['code'],
              order:            order,
              transaction_type: response['type']
            )
          end
        end
      end

      private

      def send_request(order, adjustment_reason, options)
        adjust_transaction_model = SpreeAvataxOfficial::Transactions::AdjustPresenter.new(
          order:             order,
          adjustment_reason: adjustment_reason
        ).to_json

        client.adjust_transaction(
          company_code,
          order.avatax_sales_invoice_code,
          adjust_transaction_model,
          options
        )
      end
    end
  end
end
