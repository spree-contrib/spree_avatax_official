module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    private

    delegate :company_code, to: 'SpreeAvataxOfficial::Config'

    def client
      AvaTax::Client.new(logger: true)
    end

    def request_result(response, object)
      if response['error'].present?
        logger.error(object, response)

        return failure(response)
      end

      yield response if block_given?

      logger.info(response, object)

      success(response)
    end

    def create_transaction!(code:, order:, transaction_type:)
      SpreeAvataxOfficial::Transaction.create!(
        code:             code,
        order:            order,
        transaction_type: transaction_type
      )
    end

    def logger
      @logger ||= SpreeAvataxOfficial::AvataxLog.new
    end
  end
end
