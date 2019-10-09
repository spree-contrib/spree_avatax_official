require 'spec_helper'

describe Spree::Admin::UsersController, type: :controller do
  let(:user)           { create(:user) }
  let(:entry_use_code) { create(:avalara_entity_use_code) }

  stub_authorization!

  describe '#avalara_information' do
    context 'GET action' do
      it 'render template and success status' do
        get :avalara_information, params: { id: user.id }

        expect(response.status).to eq 200
        expect(response).to render_template(:avalara_information)
      end
    end

    context 'PUT action' do
      let(:update_params) {
        {
          id: user.id,
          user: {
            spree_avatax_official_entity_use_codes_id: entry_use_code.id,
            exemption_number: '1'
          }
        }
      }

      it 'update avalara information' do
        put :avalara_information, params: update_params

        updated_user = Spree::User.find(user.id)

        expect(updated_user.reload.exemption_number).to eq update_params[:user][:exemption_number]
        expect(updated_user.reload.spree_avatax_official_entity_use_codes_id).to eq update_params[:user][:spree_avatax_official_entity_use_codes_id]

        expect(response).to render_template(:avalara_information)
      end
    end
  end

end
