module SpreeAvataxOfficial
  module Transactions
    class AdjustService < SpreeAvataxOfficial::Base
      def call(order:, adjustment_reason:, adjustment_description: '', options: {}) # rubocop:disable Metrics/MethodLength
        response = send_request(order, adjustment_reason, adjustment_description, options)

        request_result(response, order) do
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

      def send_request(order, adjustment_reason, adjustment_description, options) # rubocop:disable Metrics/MethodLength
        adjust_transaction_model = SpreeAvataxOfficial::Transactions::AdjustPresenter.new(
          order:                  order,
          adjustment_reason:      adjustment_reason,
          adjustment_description: adjustment_description
        ).to_json

        logger.info(adjust_transaction_model)

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
