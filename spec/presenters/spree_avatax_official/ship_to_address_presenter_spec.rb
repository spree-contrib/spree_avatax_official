require 'spec_helper'

describe SpreeAvataxOfficial::ShipToAddressPresenter do
  describe '#to_json' do
    subject { described_class.new(address: address).to_json }

    let(:address) { create(:address) }

    let(:result) do
      {
        line1:      address.address1,
        line2:      address.address2,
        city:       address.city,
        region:     address.state.try(:abbr),
        country:    address.country.try(:iso),
        postalCode: address.zipcode
      }
    end

    it 'serializes the object' do
      expect(subject).to eq result
    end

    context 'with address line longer than 50 characters' do
      let(:very_long_address) { FFaker::Lorem.characters(100) }

      it 'takes first 50 characters from the address line to prevent error' do
        address.address1 = very_long_address

        expect(subject[:line1]).to eq very_long_address.first(50)
      end
    end
  end
end
