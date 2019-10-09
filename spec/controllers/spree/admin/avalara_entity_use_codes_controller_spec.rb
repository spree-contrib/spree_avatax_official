require 'spec_helper'

describe Spree::Admin::AvalaraEntityUseCodesController, type: :controller do
  let(:avatax_entity_use_code) { create(:avalara_entity_use_code) }

  stub_authorization!

  before { DatabaseCleaner.clean }

  describe '#index' do
    subject { get :index }

    it 'return success response' do
      expect(response.status).to eq 200
    end

    it 'render index template' do
      expect(subject).to render_template(:index)
    end
  end

  describe '#new' do
    subject { get :new }

    it 'return success response' do
      expect(response.status).to eq 200
    end

    it 'render new template' do
      expect(subject).to render_template(:new)
    end
  end

  describe '#edit' do
    it 'return success response' do
      get :edit, params: { id: avatax_entity_use_code.id }

      expect(response.status).to eq 200
      expect(response).to render_template(:edit)
    end
  end

  describe '#create' do
    context 'with valid params' do
      subject { post :create, params: params }

      let(:params) {
        {
          entity_use_code: {
            code: 'KB',
            name: 'Internal exemption',
            description: 'Lorem ipsum ...'
          }
        }
      }

      it 'create entity use code' do
        expect { subject }.to change { SpreeAvataxOfficial::EntityUseCode.count }.by(1)
      end

      it 'redirect to index page' do
        expect(subject).to redirect_to(admin_avalara_entity_use_codes_path)
      end
    end

    context 'with no-valid params' do
      let(:invalid_params) {
        {
          entity_use_code: {
            code: 1,
            name: nil
          }
        }
      }

      it 'entity use code not created' do
        post :create, params: invalid_params

        expect(response.status).to eq 302
        expect(subject).to redirect_to(new_admin_avalara_entity_use_code_path)
        expect { response }.not_to change { SpreeAvataxOfficial::EntityUseCode.count }
      end
    end
  end

  describe '#update' do
    context 'with valid params' do
      subject { put :update, params: valid_params }

      let(:valid_params) {
        {
          id: avatax_entity_use_code,
          entity_use_code: {
            code: 'ABCD'
          }
        }
      }

      it 'redirect to index page' do
        expect(subject).to redirect_to(admin_avalara_entity_use_codes_path)
      end

      it 'update use_code' do
        expect { subject }.to change { avatax_entity_use_code.reload.code }.from('A').to('ABCD')
      end
    end

    context 'with no-valid params' do
      subject { put :update, params: invalid_params }

      let(:invalid_params) {
        {
          id: 's',
          entity_use_code: {
            name: 'Federal exclusion'
          }
        }
      }

      it 'redirect to index page' do
        expect(subject).to redirect_to(admin_avalara_entity_use_codes_path)
      end

      it 'stay with the same name' do
        expect { subject }.not_to change { avatax_entity_use_code.reload.name }
      end
    end
  end
end
