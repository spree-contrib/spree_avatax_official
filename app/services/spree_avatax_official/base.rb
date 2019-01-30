module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    private

    delegate :company_code, to: 'SpreeAvataxOfficial::Config'

    def client
      AvaTax::Client.new(logger: true)
    end
  end
end
