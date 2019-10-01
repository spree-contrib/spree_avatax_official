require 'spec_helper'

describe 'Update Avatax Settings spec', type: :feature do
  stub_authorization!

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
