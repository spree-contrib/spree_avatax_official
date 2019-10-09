module Spree
  module Admin
    module UsersControllerDecorator
      def avalara_information
        if request.put?
          if @user.update_attributes(user_params)
            flash.now[:success] = Spree.t(:account_updated)
          end
        end

        render :avalara_information
      end

      private

      def user_params
        params.require(:user).permit(:spree_avatax_official_entity_use_codes_id, :exemption_number, :vat_id)
      end
    end
  end
end

::Spree::Admin::UsersController.prepend(Spree::Admin::UsersControllerDecorator)
