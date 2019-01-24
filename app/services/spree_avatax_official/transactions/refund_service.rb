module SpreeAvataxOfficial
  module Transactions
    class RefundService
      prepend ::Spree::ServiceModule::Base

      def call(return_authorization:)
        refund_transaction(return_authorization).tap do |transaction|
          transaction.key?('error') ? failure(transaction) : success(transaction)
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

      def client
        AvaTax::Client.new(logger: true)
      end

      def company_code
        SpreeAvataxOfficial::Config[:company_code]
      end

      def refund_model(return_authorization)
        RefundPresenter.new(
          return_authorization: return_authorization
        ).to_json
      end
    end
  end
end
