module Spree
  module Admin
    class AvataxSettingsController < Spree::Admin::BaseController
      def edit
        @ship_from_address = SpreeAvataxOfficial::Config.ship_from_address
        @country = if @ship_from_address[:country].blank?
                     Spree::Country.default
                   else
                     Spree::Country.find_by(iso3: @ship_from_address[:country])
                   end
        @states = @country.try(:states)
      end

      def update
        if params[:endpoint].present? && params[:endpoint] !~ URI::DEFAULT_PARSER.make_regexp
          flash[:error] = Spree.t('spree_avatax_official.wrong_endpoint_url')
        else
          SpreeAvataxOfficial::Settings::UpdateService.call(params: params)
          flash[:success] = Spree.t('spree_avatax_official.settings_updated')
        end

        redirect_to edit_admin_avatax_settings_path
      end
    end
  end
end
