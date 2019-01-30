module SpreeAvataxOfficial
  module Transactions
    class VoidService < SpreeAvataxOfficial::Base
      def call(order:, options: {})
        response = send_request(order, options)

        return failure(response) if response['error'].present?

        success(response)
      end

      private

      def send_request(order, options)
        response = client.void_transaction(
          company_code,
          order.avatax_sales_invoice_transaction&.code,
          { code: 'DocVoided' },
          options
        )
      end
    end
  end
end
