require 'spec_helper'

describe SpreeAvataxOfficial::Seeder do
  describe '#seed!' do
    subject { described_class.new.seed! }

    let!(:pennslyvania) { create(:state, name: 'Pennsylvania', abbr: 'PA') }
    let!(:shipping_method) { create(:shipping_method, tax_category: nil) }
    let(:clothing_tax_category) { Spree::TaxCategory.find_by(name: 'Clothing') }
    let(:shipping_tax_category) { Spree::TaxCategory.find_by(name: 'Shipping') }

    it 'creates Clothing and Shipping tax categories and assigns Shipping tax category' do
      subject

      expect(clothing_tax_category).to be_present
      expect(clothing_tax_category.tax_code).to eq 'P0000000'
      expect(shipping_tax_category).to be_present
      expect(shipping_tax_category.tax_code).to eq 'FR'
      expect(shipping_method.reload.tax_category).to eq shipping_tax_category
    end
  end
end
