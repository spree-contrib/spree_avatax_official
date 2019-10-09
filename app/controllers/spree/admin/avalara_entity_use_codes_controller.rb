module Spree
  module Admin
    class AvalaraEntityUseCodesController < Spree::Admin::BaseController
      before_action :load_use_code, only: %i[edit update destroy]

      def index
        @use_codes = SpreeAvataxOfficial::EntityUseCode.all.order(code: :asc)
        respond_with(@use_codes)
      end

      def new
        @use_code = SpreeAvataxOfficial::EntityUseCode.new
      end

      def edit; end

      def update
        if @use_code.update(entity_use_codes_params)
          flash[:notice] = Spree.t('spree_avatax_official.entity_use_code.use_code_updated')
          redirect_to admin_avalara_entity_use_codes_path
        end
      end

      def create
        @use_code = SpreeAvataxOfficial::EntityUseCode.new(entity_use_codes_params)
        if @use_code.save
          flash[:notice] = Spree.t('spree_avatax_official.entity_use_code.use_code_created')
          redirect_to admin_avalara_entity_use_codes_path
        else
          flash[:error] = @use_code.errors.full_messages.join('. ')
          redirect_to new_admin_avalara_entity_use_code_path
        end
      end

      def destroy
        if @use_code.destroy
          flash[:notice] = Spree.t('spree_avatax_official.entity_use_code.use_code_removed')
          redirect_to admin_avalara_entity_use_codes_path
        end
      end

      private

      def load_use_code
        @use_code ||= SpreeAvataxOfficial::EntityUseCode.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        flash[:error] = e.message
        redirect_to admin_avalara_entity_use_codes_path
      end

      def entity_use_codes_params
        params.require(:entity_use_code).permit(:code, :name, :description)
      end
    end
  end
end
