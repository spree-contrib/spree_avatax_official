module Spree
  module Admin
    module UsersControllerDecorator
      def self.prepended(base)
        base.before_action :load_use_codes, only: :avalara_information
      end

      def avalara_information
        if request.put? && @user.update_attributes(user_params)
          flash.now[:success] = Spree.t(:account_updated)
        end

        render :avalara_information
      end

      private

      def load_use_codes
        return if request.put?

        @use_codes = SpreeAvataxOfficial::EntityUseCode.all.map { |use_code| ["#{use_code.code} - #{use_code.name}", use_code.id] }
      end

      def user_params
        params.require(:user).permit(:spree_avatax_official_entity_use_codes_id, :exemption_number, :vat_id)
      end
    end
  end
end

::Spree::Admin::UsersController.prepend(Spree::Admin::UsersControllerDecorator)
