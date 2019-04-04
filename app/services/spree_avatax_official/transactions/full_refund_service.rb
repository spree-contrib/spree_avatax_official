module SpreeAvataxOfficial
  module Transactions
    class FullRefundService < SpreeAvataxOfficial::Base
      def call(order:)
        create_refund(order).tap do |response|
          return request_result(response, order) do
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
        logger.info(refund_model(order))

        client.refund_transaction(
          company_code,
          order.number,
          refund_model(order)
        )
      end

      def refund_model(order)
        @refund_model ||= FullRefundPresenter.new(order: order).to_json
      end
    end
  end
end
