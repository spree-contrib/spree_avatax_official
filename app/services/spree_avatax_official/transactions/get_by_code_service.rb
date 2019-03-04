module SpreeAvataxOfficial
  module Transactions
    class GetByCodeService < SpreeAvataxOfficial::Base
      def call(order:, type: 'SalesInvoice')
        code = transaction_code(order, type)

        return failure(I18n.t('spree_avatax_official.get_by_code_service.missing_code')) if code.nil?

        request_result(get_by_code(code))
      end

      private

      def get_by_code(code)
        client.get_transaction_by_code(
          company_code,
          code
        )
      end

      def transaction_code(order, type)
        order
          .avatax_transactions
          .find_by(transaction_type: type)
          .try(:code)
      end
    end
  end
end
