module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    APP_NAME    = 'a0o0b000005HsXPAA0'.freeze
    APP_VERSION = 'Spree by Spark'.freeze

    private

    delegate :company_code, to: 'SpreeAvataxOfficial::Config'

    def client
      AvaTax::Client.new(
        app_name:    APP_NAME,
        app_version: APP_VERSION,
        logger:      true
      )
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
