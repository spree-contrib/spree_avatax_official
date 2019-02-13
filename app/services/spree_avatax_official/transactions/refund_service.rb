module SpreeAvataxOfficial
  module Transactions
    class RefundService < SpreeAvataxOfficial::Base
      def call(refund_object:)
        refund_transaction(refund_object).tap do |response|
          return request_result(response) do
            create_transaction(response['code'], order(refund_object))
          end
        end
      end

      private

      def refund_transaction(refund_object)
        client.refund_transaction(
          company_code,
          order(refund_object).number,
          refund_model(refund_object)
        )
      end

      def order(refund_object)
        case refund_object
        when ::Spree::ReturnAuthorization
          refund_object.order
        when ::Spree::ReturnItem
          refund_object.return_authorization.order
        end
      end

      def refund_model(refund_object)
        case refund_object
        when ::Spree::ReturnAuthorization
          ReturnAuthorizationPresenter.new(return_authorization: refund_object).to_json
        when ::Spree::ReturnItem
          ReturnItemPresenter.new(return_item: refund_object).to_json
        end
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
