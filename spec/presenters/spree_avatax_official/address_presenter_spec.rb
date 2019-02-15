require 'spec_helper'

describe SpreeAvataxOfficial::AddressPresenter do
  subject { described_class.new(address: address, address_type: address_type) }

  describe '#to_json' do
    let(:address) { create(:address) }
    let(:address_type) { 'ShipFrom' }

    let(:result) do
      {
        address_type => {
          line1:      address.address1,
          line2:      address.address2,
          city:       address.city,
          region:     address.state&.abbr,
          country:    address.country&.iso,
          postalCode: address.zipcode
        }
      }
    end

    it 'serializes the object' do
      expect(subject.to_json).to eq result
    end
  end
end
