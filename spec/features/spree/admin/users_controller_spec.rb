require 'spec_helper'

describe Spree::Admin::UsersController, type: :feature do
  stub_authorization!

  describe '#index' do
    let!(:user)                    { create(:user) }
    let!(:avalara_entity_use_code) { create(:avalara_entity_use_code) }

    before { visit spree.avalara_information_admin_user_path(user) }

    scenario 'index page return 200 status' do
      expect(page.status_code).to be(200)
      expect(page).to have_content avalara_entity_use_code.code
    end
  end

  describe '#edit' do
    let!(:user)                    { create(:user) }
    let!(:avalara_entity_use_code) { create(:avalara_entity_use_code) }

    before { visit spree.avalara_information_admin_user_path(user) }

    scenario 'update avalara entity use code' do
      fill_in 'user_exemption_number', with: '10'

      click_button 'Update'

      expect(page.status_code).to be(200)
      visit spree.avalara_information_admin_user_path(user)
      expect(page).to have_content(user.exemption_number)
    end
  end
end
