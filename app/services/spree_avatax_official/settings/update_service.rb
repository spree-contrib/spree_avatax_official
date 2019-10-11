module SpreeAvataxOfficial
  module Settings
    class UpdateService < SpreeAvataxOfficial::Base
      def call(params:)
        update_settings(params)
      end

      private

      def update_settings(params)
        update_address_settings(params[:ship_from])

        SpreeAvataxOfficial::Config.account_number             = params[:account_number] if params[:account_number].present?
        SpreeAvataxOfficial::Config.license_key                = params[:license_key] if params[:license_key].present?
        SpreeAvataxOfficial::Config.company_code               = params[:company_code] if params[:company_code].present?
        SpreeAvataxOfficial::Config.endpoint                   = params[:endpoint] if params[:endpoint].present?
        SpreeAvataxOfficial::Config.address_validation_enabled = params[:address_validation_enabled] if params[:address_validation_enabled].present?
        SpreeAvataxOfficial::Config.commit_transaction_enabled = params[:commit_transaction_enabled].present?
      end

      def update_address_settings(ship_from_params)
        return unless ship_from_params

        SpreeAvataxOfficial::Config.ship_from_address = {
            line1:      ship_from_params[:line1],
            line2:      ship_from_params[:line2],
            city:       ship_from_params[:city],
            region:     ship_from_params[:region],
            country:    ship_from_params[:country],
            postalCode: ship_from_params[:postal_code]
        }
      end
    end
  end
end
