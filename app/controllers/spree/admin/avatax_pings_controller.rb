module Spree
  module Admin
    class AvataxPingsController < Spree::Admin::BaseController
      respond_to :html

      def create
        response = SpreeAvataxOfficial::Utilities::PingService.call
        if response.success? && response['value']['authenticated']
          flash[:success] = Spree.t('spree_avatax_official.connected_successful')
        elsif response.success? && !response['value']['authenticated']
          flash[:error] = Spree.t('spree_avatax_official.unauthorized')
        elsif response['value'] =~ /bad URI/i
          flash[:error] = Spree.t('spree_avatax_official.wrong_endpoint_url')
        else
          flash[:error] = Spree.t('spree_avatax_official.connection_rejected')
        end
        redirect_to edit_admin_avatax_settings_path
      end
    end
  end
end
