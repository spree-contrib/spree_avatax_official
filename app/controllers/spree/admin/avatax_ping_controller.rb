module Spree
  module Admin
    class AvataxPingController < Spree::Admin::BaseController
      respond_to :html

      def create
        response = SpreeAvataxOfficial::Utilities::PingService.call

        if response.success?
          flash[:success] = "Connected successful"
        else
          flash[:error] = "Avatax rejected connection with error: #{response.error}"
        end
        redirect_to edit_admin_avatax_settings_path
      end
    end
  end
end
