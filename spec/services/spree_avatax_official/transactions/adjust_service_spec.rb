require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::AdjustService do
  describe '#call' do
    context 'with correct parameters' do
      subject do
        described_class.call(
          order:             order,
          ship_from_address: ship_from_address,
          adjustment_reason: 'PriceAdjusted'
        )
      end

      let(:order) { create(:order_with_line_items, ship_address: create(:usa_address)) }
      let(:ship_from_address) { create(:usa_address) }

      it 'returns positive result' do
        VCR.use_cassette('spree_avatax_official/transactions/adjust/invoice_order_success') do
          SpreeAvataxOfficial::Transactions::CreateService.call(
            order:             order,
            ship_from_address: ship_from_address,
            transaction_type:  'SalesInvoice'
          )

          result   = subject
          response = result.value

          expect(result.success?).to eq true
          expect(response['type']).to eq 'SalesInvoice'
          expect(response['status']).to eq 'Saved'
          expect(response['lines'].size).to eq 1
          expect(SpreeAvataxOfficial::Transaction.count).to eq 1
        end
      end
    end

    context 'with incorrect parameters' do
      subject do
        described_class.call(
          order:             order,
          ship_from_address: ship_from_address,
          adjustment_reason: ''
        )
      end

      let(:order) { create(:order_with_line_items, ship_address: create(:usa_address)) }
      let(:ship_from_address) { create(:usa_address) }

      it 'returns negative result' do
        VCR.use_cassette('spree_avatax_official/transactions/adjust/failure') do
          SpreeAvataxOfficial::Transactions::CreateService.call(
            order:             order,
            ship_from_address: ship_from_address,
            transaction_type:  'SalesInvoice'
          )

          result   = subject
          response = result.value

          expect(result.success?).to eq false
          expect(response['error']).to be_present
          expect(response['error']['code']).to eq 'ModelStateInvalid'
        end
      end
    end
  end
end
