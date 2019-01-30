require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::VoidService do
  describe '#call' do
    subject { described_class.call(order: order) }

    let(:order) { create(:completed_order_with_totals, ship_address: create(:usa_address)) }
    let(:ship_from_address) { create(:usa_address) }

    context 'with correct parameters' do
      it 'returns positive result' do
        VCR.use_cassette('spree_avatax_official/transactions/void/success') do
          SpreeAvataxOfficial::Transactions::CreateService.call(
            order: order,
            ship_from_address: ship_from_address,
            transaction_type: 'SalesInvoice'
          )

          result = subject
          response = result.value

          expect(result.success?).to eq true
          expect(response['status']).to eq 'Cancelled'
        end
      end
    end
  end
end
