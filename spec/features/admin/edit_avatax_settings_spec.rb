require 'spec_helper'

describe 'Edit Avatax Settings spec', type: :feature do
  stub_authorization!

  it 'renders edit page' do
    visit '/admin/avatax_settings/edit'

    expect(page).to have_content(I18n.t('spree_avatax_official.settings'))
  end
end
