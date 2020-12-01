require 'spec_helper'

describe 'Update Avatax Settings spec', type: :feature do
  stub_authorization!

  before { create(:country) }

  describe 'company code' do
    around do |example|
      company_code = SpreeAvataxOfficial::Config.company_code
      example.run
      SpreeAvataxOfficial::Config.company_code = company_code
    end

    it 'updates avatax settings' do
      visit '/admin/avatax_settings/edit'

      fill_in 'company_code', with: 'test123'
      click_button 'Save AvaTax preferences'

      expect(SpreeAvataxOfficial::Config.company_code).to eq 'test123'
      expect(current_path).to                             eq '/admin/avatax_settings/edit'
    end
  end

  describe 'endpoint URL' do
    around do |example|
      endpoint = SpreeAvataxOfficial::Config.endpoint
      example.run
      SpreeAvataxOfficial::Config.endpoint = endpoint
    end

    context 'when endpoint URL is valid' do
      it 'updates avatax settings' do
        visit '/admin/avatax_settings/edit'

        fill_in 'endpoint', with: 'https://sandbox-rest.avatax.com'
        click_button 'Save AvaTax preferences'

        expect(SpreeAvataxOfficial::Config.endpoint).to eq 'https://sandbox-rest.avatax.com'
        expect(page).to have_current_path '/admin/avatax_settings/edit'
      end
    end

    context 'when endpoint URL is invalid' do
      it 'does not update avatax settings' do
        visit '/admin/avatax_settings/edit'

        fill_in 'endpoint', with: 'wrong-url'
        click_button 'Save AvaTax preferences'

        expect(SpreeAvataxOfficial::Config.endpoint).not_to eq 'wrong-url'
        expect(page).to have_current_path '/admin/avatax_settings/edit'
        expect(page).to have_content 'Endpoint URL seems to be invalid'
      end
    end
  end

  describe 'enable commiting transactions' do
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

          click_button 'Save AvaTax preferences'

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

          click_button 'Save AvaTax preferences'

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

          click_button 'Save AvaTax preferences'

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq true
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end

      context 'initially false' do
        before do
          SpreeAvataxOfficial::Config.commit_transaction_enabled = false
        end

        it 'leave commit_transaction_enabled' do
          visit '/admin/avatax_settings/edit'

          click_button 'Save AvaTax preferences'

          expect(SpreeAvataxOfficial::Config.commit_transaction_enabled).to eq false
          expect(current_path).to eq '/admin/avatax_settings/edit'
        end
      end
    end
  end

  context 'address validation' do
    around do |example|
      address_validation_enabled = SpreeAvataxOfficial::Config.address_validation_enabled
      example.run
      SpreeAvataxOfficial::Config.address_validation_enabled = address_validation_enabled
    end

    context 'when checkbox is checked' do
      it 'sets SpreeAvataxOfficial::Config.address_validation_enabled to true' do
        SpreeAvataxOfficial::Config.address_validation_enabled = false

        visit '/admin/avatax_settings/edit'
        check 'address_validation_enabled'
        click_button 'Save AvaTax preferences'

        expect(SpreeAvataxOfficial::Config.address_validation_enabled).to eq true
        expect(current_path).to                                           eq '/admin/avatax_settings/edit'
      end
    end

    context 'when checkbox is unchecked' do
      it 'sets SpreeAvataxOfficial::Config.address_validation_enabled to false' do
        SpreeAvataxOfficial::Config.address_validation_enabled = true

        visit '/admin/avatax_settings/edit'
        uncheck 'address_validation_enabled'
        click_button 'Save AvaTax preferences'

        expect(SpreeAvataxOfficial::Config.address_validation_enabled).to eq false
        expect(current_path).to                                           eq '/admin/avatax_settings/edit'
      end
    end
  end

  context 'enabling and disabling extension' do
    around do |example|
      enabled = SpreeAvataxOfficial::Config.enabled
      example.run
      SpreeAvataxOfficial::Config.enabled = enabled
    end

    context 'when checkbox is checked' do
      it 'updates enabled state to enabled' do
        SpreeAvataxOfficial::Config.enabled = false

        visit '/admin/avatax_settings/edit'
        check 'enabled'
        click_button 'Save AvaTax preferences'

        expect(current_path).to                        eq '/admin/avatax_settings/edit'
        expect(SpreeAvataxOfficial::Config.enabled).to eq true
      end
    end

    context 'when checkbox is unchecked' do
      it 'updates enabled state to disabled' do
        SpreeAvataxOfficial::Config.enabled = true

        visit '/admin/avatax_settings/edit'
        uncheck 'enabled'
        click_button 'Save AvaTax preferences'

        expect(current_path).to                        eq '/admin/avatax_settings/edit'
        expect(SpreeAvataxOfficial::Config.enabled).to eq false
      end
    end
  end
end
