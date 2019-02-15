require 'spec_helper'

describe Spree::Shipment do
  let(:shipment) { create(:shipment) }

  describe '#avatax_number' do
    it 'returns shipment id with avatax code' do
      expect(shipment.avatax_number).to eq "#{shipment.id}-FR"
    end
  end
end
