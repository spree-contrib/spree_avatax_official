module Spree
  module Admin
    class AvataxPingsController < Spree::Admin::BaseController
      respond_to :html

      def create
        response = SpreeAvataxOfficial::Utilities::PingService.call
        if response.success? && response['value']['authenticated']
          flash[:success] = "Connected successful"
        elsif response.success? && !response['value']['authenticated']
          flash[:error] = "Connected but unauthorized"
        else
          flash[:error] = "Avatax rejected connection with error: #{response.value['error']['message']}"
        end
        redirect_to edit_admin_avatax_settings_path
      end
    end
  end
end
