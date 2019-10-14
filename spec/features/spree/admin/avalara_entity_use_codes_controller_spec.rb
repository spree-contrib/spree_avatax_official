require 'spec_helper'

describe Spree::Admin::AvalaraEntityUseCodesController, type: :feature do
  stub_authorization!

  describe '#index' do
    let!(:avalara_entity_use_code) { create(:avalara_entity_use_code) }

    before { visit spree.admin_avalara_entity_use_codes_path }

    scenario 'index page return 200 status' do
      expect(page.status_code).to be(200)
      expect(page).to have_content avalara_entity_use_code.code
    end
  end

  describe '#new' do
    before { visit spree.new_admin_avalara_entity_use_code_path }

    scenario 'new page return 200 status' do
      expect(page.status_code).to be(200)
    end

    scenario 'create new avalara entity use code' do
      fill_in 'entity_use_code_code', with: 'avalara code'
      fill_in 'entity_use_code_name', with: 'avalara code name'

      click_button 'Create'

      expect(page.status_code).to be(200)
      expect(page).to have_content 'avalara code'
    end
  end

  describe '#edit' do
    let!(:avalara_entity_use_code) { create(:avalara_entity_use_code) }

    before { visit spree.edit_admin_avalara_entity_use_code_path(avalara_entity_use_code) }

    scenario 'update avalara entity use code' do
      fill_in 'entity_use_code_code', with: 'avalara code updated'

      click_button 'Update'

      expect(page.status_code).to be(200)
      expect(page).to have_content 'avalara code updated'
    end
  end

  describe '#destroy' do
    let!(:avalara_entity_use_code) { create(:avalara_entity_use_code) }

    scenario 'destory avalara entity use code', js: true do
      visit spree.admin_avalara_entity_use_codes_path

      expect(page).to have_content(avalara_entity_use_code.code)

      within("tr#entity_use_code_#{avalara_entity_use_code.id}") do
        page.accept_alert do
          click_on('Delete')
        end

        expect(page.document).to have_content('Entity use code removed')
      end

      visit spree.admin_avalara_entity_use_codes_path
      expect(page.current_path).to eq spree.admin_avalara_entity_use_codes_path
      expect(page).not_to have_content(avalara_entity_use_code.name)
    end
  end
end
