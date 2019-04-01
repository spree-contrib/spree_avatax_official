require 'spec_helper'

describe SpreeAvataxOfficial::Address::Validate do
  describe '#call' do
    subject { described_class.call(address: address) }

    context 'with valid address' do
      let(:address) { create(:usa_address) }

      it 'returns success' do
        VCR.use_cassette('spree_avatax_official/address/validate_success') do
          response = subject

          expect(response.success?).to eq true
        end
      end
    end

    context 'with invalid address' do
      let(:address) { create(:invalid_usa_address) }

      it 'returns failure with messages' do
        VCR.use_cassette('spree_avatax_official/address/validate_failure') do
          response = subject

          expect(response.failure?).to eq true
          expect(response.value['messages']).to be_present
        end
      end
    end
  end
end
