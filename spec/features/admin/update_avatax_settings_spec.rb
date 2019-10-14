require 'spec_helper'

describe 'Update Avatax Settings spec', type: :feature do
  stub_authorization!

  describe 'company code' do
    around do |example|
      company_code = SpreeAvataxOfficial::Config.company_code
      example.run
      SpreeAvataxOfficial::Config.company_code = company_code
    end

    it 'updates avatax settings' do
      create(:country)

      visit '/admin/avatax_settings/edit'

      fill_in 'company_code', with: 'test123'
      click_button I18n.t('spree_avatax_official.save_preferences')

      expect(SpreeAvataxOfficial::Config.company_code).to eq 'test123'
      expect(current_path).to                             eq '/admin/avatax_settings/edit'
    end
  end

  describe 'enable commiting transactions' do
    before { create(:country) }

    context 'toggle committing transactions' do
      context 'initially enabled' do
        around do |example|
          SpreeAvataxOfficial::Config.commit_transaction_enabled = true
          example.run
          SpreeAvataxOfficial::Config.commit_transaction_enabled = true
        end

        it 'disable committing transactions' do
          visit '/admin/avatax_settings/edit'

          uncheck 'commit_transaction_enabled'

          click_button I18n.t('spree_avatax_official.save_preferences')

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq false
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end

      context 'initially disabled' do
        around do |example|
          SpreeAvataxOfficial::Config.commit_transaction_enabled = false
          example.run
          SpreeAvataxOfficial::Config.commit_transaction_enabled = true
        end

        it 'enable committing transactions' do
          visit '/admin/avatax_settings/edit'

          check 'commit_transaction_enabled'

          click_button I18n.t('spree_avatax_official.save_preferences')

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq true
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end
    end

    context "doesn't toggle committing transactions" do
      context 'initially true' do
        before { SpreeAvataxOfficial::Config.commit_transaction_enabled = true }

        it 'leave commit_transaction_enabled' do
          visit '/admin/avatax_settings/edit'

          click_button I18n.t('spree_avatax_official.save_preferences')

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq true
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end

      context 'initially false' do
        around do |example|
          SpreeAvataxOfficial::Config.commit_transaction_enabled = false
          example.run
          SpreeAvataxOfficial::Config.commit_transaction_enabled = true
        end

        it 'leave commit_transaction_enabled' do
          visit '/admin/avatax_settings/edit'

          click_button I18n.t('spree_avatax_official.save_preferences')

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq false 
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end
    end
  end
end
