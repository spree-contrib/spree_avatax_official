module SpreeAvataxOfficial
  class Base
    prepend ::Spree::ServiceModule::Base

    private

    def client
      AvaTax::Client.new(logger: true)
    end

    def company_code
      SpreeAvataxOfficial::Config[:company_code]
    end
  end
end
