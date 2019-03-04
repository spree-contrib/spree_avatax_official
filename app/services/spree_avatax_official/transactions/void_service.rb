module SpreeAvataxOfficial
  module Transactions
    class VoidService < SpreeAvataxOfficial::Base
      def call(order:, options: {})
        if order.avatax_sales_invoice_transaction.blank?
          return failure(I18n.t('spree_avatax_official.void_service.missing_sales_invoice_transaction'))
        end

        response = send_request(order, options)

        request_result(response, order)
      end

      private

      def send_request(order, options)
        logger.info(options, order)

        client.void_transaction(
          company_code,
          order.avatax_sales_invoice_code,
          { code: 'DocVoided' },
          options
        )
      end
    end
  end
end
