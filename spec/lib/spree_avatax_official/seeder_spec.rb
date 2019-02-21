require 'spec_helper'

describe SpreeAvataxOfficial::Seeder do
  describe '#seed!' do
    subject { described_class.new.seed! }

    context 'when ship from address preference from SpreeAvataxCertified is present' do
      let!(:usa) { create(:country, name: 'United States', iso3: 'USA') }
      let!(:pennslyvania) { create(:state, name: 'Pennsylvania', abbr: 'PA') }
      let(:address_in_json) do
        {
          Address1: '822 Reed St',
          Address2: '',
          City:     'Philadelphia',
          Region:   'Pennsylvania',
          Zip5:     '19147',
          Zip4:     '',
          Country:  'United States'
        }.to_json
      end
      let(:create_avatax_origin_preference) do
        preference            = ::Spree::Preference.new(key: 'spree/app_configuration/avatax_origin', value: address_in_json)
        preference.value_type = 'string' if preference.respond_to?(:value_type) # Spree 2.2 has this extra field
        preference.save!
      end
      let(:result) do
        {
          line1:      '822 Reed St',
          line2:      '',
          city:       'Philadelphia',
          region:     'PA',
          country:    'USA',
          postalCode: '19147'
        }
      end

      around do |example|
        create_avatax_origin_preference
        example.run
        SpreeAvataxOfficial::Config.ship_from_address = {}
      end

      it 'copies the value to SpreeAvataxOfficial::Config.ship_from_address' do
        expect(SpreeAvataxOfficial::Config.ship_from_address).to be_blank

        subject

        expect(SpreeAvataxOfficial::Config.ship_from_address).to eq result
      end
    end
  end
end
