module SpreeAvataxOfficial
  module Transactions
    class PartialRefundService < SpreeAvataxOfficial::Base
      def call(order:, refund_items:)
        response = send_request(order, refund_items)

        request_result(response, order) do
          unless response['id'].to_i.zero?
            create_transaction!(
              code:             response['code'],
              order:            order,
              transaction_type: SpreeAvataxOfficial::Transaction::RETURN_INVOICE
            )
          end
        end
      end

      private

      def send_request(order, refund_items)
        refund_transaction_model = SpreeAvataxOfficial::Transactions::PartialRefundPresenter.new(
          order:        order,
          refund_items: refund_items
        ).to_json

        logger.info(refund_transaction_model)

        client.create_transaction(refund_transaction_model)
      end
    end
  end
end
