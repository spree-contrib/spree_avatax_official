module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    private

    delegate :company_code, to: 'SpreeAvataxOfficial::Config'

    def client
      AvaTax::Client.new(logger: true)
    end

    def request_result(response)
      return failure(response) if response['error'].present?

      yield response if block_given?

      success(response)
    end

    def create_transaction!(code:, order:, transaction_type:)
      SpreeAvataxOfficial::Transaction.create!(
        code:             code,
        order:            order,
        transaction_type: transaction_type
      )
    end
  end
end
