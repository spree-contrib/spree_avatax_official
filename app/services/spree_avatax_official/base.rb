module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    APP_NAME           = 'a0o0b000005HsXPAA0'.freeze
    APP_VERSION        = 'Spree by Spark'.freeze
    CONNECTION_OPTIONS = ::AvaTax::Configuration::DEFAULT_CONNECTION_OPTIONS.merge(
      request: {
        timeout:      SpreeAvataxOfficial::Config.read_timeout,
        open_timeout: SpreeAvataxOfficial::Config.open_timeout
      }
    ).freeze

    private

    delegate :company_code, to: 'SpreeAvataxOfficial::Config'

    def client
      AvaTax::Client.new(
        app_name:           APP_NAME,
        app_version:        APP_VERSION,
        connection_options: CONNECTION_OPTIONS,
        logger:             true
      )
    end

    def request_result(response, object)
      return handle_error(object, response.presence) if response.blank? || response['error'].present?

      yield response if block_given?

      logger.info(response, object)

      success(response)
    end

    def handle_error(object, response)
      response ||= I18n.t('spree_avatax_official.base.missing_company_code')

      logger.error(object, response)

      failure(response)
    end

    def refund_transaction_code(order_number, refundable_id)
      "#{order_number}-#{refundable_id}"
    end

    def create_transaction!(order:, code: nil, transaction_type: nil)
      SpreeAvataxOfficial::Transaction.create!(
        code:             code || order.number,
        order:            order,
        transaction_type: transaction_type || SpreeAvataxOfficial::Transaction::SALES_INVOICE
      )
    end

    def logger
      @logger ||= SpreeAvataxOfficial::AvataxLog.new
    end
  end
end
