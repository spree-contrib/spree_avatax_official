module SpreeAvataxOfficial
  module Transactions
    class RefundService < SpreeAvataxOfficial::Base
      def call(return_authorization:)
        refund_transaction(return_authorization).tap do |response|
          return request_result(response) do
            create_transaction(response['code'], return_authorization.order)
          end
        end
      end

      private

      def refund_transaction(return_authorization)
        client.refund_transaction(
          company_code,
          return_authorization.order.number,
          refund_model(return_authorization)
        )
      end

      def refund_model(return_authorization)
        RefundPresenter.new(
          return_authorization: return_authorization
        ).to_json
      end

      def create_transaction(code, order)
        SpreeAvataxOfficial::Transactions::SaveCodeService.call(
          code:  code,
          order: order,
          type:  SpreeAvataxOfficial::Transaction::RETURN_INVOICE
        )
      end
    end
  end
end
