require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::VoidService do
  let(:order) { create(:completed_order_with_totals, ship_address: create(:usa_address)) }
  let(:ship_from_address) { create(:usa_address) }

  describe '#call' do
    subject { described_class.call(order: order) }

    context 'with correct parameters' do
      it 'returns positive result' do
        VCR.use_cassette('spree_avatax_official/transactions/void/success') do
          SpreeAvataxOfficial::Transactions::CreateService.call(
            order:             order,
            ship_from_address: ship_from_address,
            transaction_type:  'SalesInvoice'
          )

          result   = subject
          response = result.value

          expect(result.success?).to eq true
          expect(response['status']).to eq 'Cancelled'
        end
      end
    end

    context 'when order does NOT have SalesInvoice transaction' do
      it 'returns negative result' do
        result   = subject
        response = result.value

        expect(result.success?).to eq false
        expect(response).to eq I18n.t('spree_avatax_official.void_service.missing_sales_invoice_transaction')
      end
    end
  end
end
