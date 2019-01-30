module SpreeAvataxOfficial
  module Transactions
    class CreateService
      prepend ::Spree::ServiceModule::Base

      def call(order:, ship_from_address:, transaction_type:, options: {})
        response = send_request(order, ship_from_address, transaction_type, options)

        return failure(response) if response['error'].present?

        unless response['id'].to_i.zero?
          SpreeAvataxOfficial::Transaction.create!(id: response['id'], order: order, transaction_type: transaction_type)
        end

        success(response)
      end

      private

      def send_request(order, ship_from_address, transaction_type, options)
        create_transaction_model = SpreeAvataxOfficial::Transactions::CreatePresenter.new(
          order: order,
          ship_from_address: ship_from_address,
          transaction_type: transaction_type
        ).to_json

        response = AvaTax::Client.new(logger: true).create_transaction(create_transaction_model, options)
      end
    end
  end
end
