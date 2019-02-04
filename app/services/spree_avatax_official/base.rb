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
  end
end
