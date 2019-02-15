require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::GetByCodeService do
  describe '#call' do
    subject { described_class.call(params) }

    let(:order)               { create(:order) }
    let!(:return_transaction) { create(:spree_avatax_official_transaction, order: order, transaction_type: 'ReturnInvoice', code: 'test321') }
    let!(:sales_transaction)  { create(:spree_avatax_official_transaction, order: order, transaction_type: 'SalesInvoice', code: 'test123') }

    context 'with correct params' do
      context 'with default transaction type' do
        let(:params) { { order: order } }

        it 'returns success' do
          VCR.use_cassette('spree_avatax_official/transactions/get_by_code/order_without_type_success') do
            expect(subject.value['type']).to eq 'SalesInvoice'
          end
        end
      end

      context 'with custom transaction type' do
        let(:params) { { order: order, type: 'ReturnInvoice' } }

        it 'returns success' do
          VCR.use_cassette('spree_avatax_official/transactions/get_by_code/order_with_type_success') do
            expect(subject.value['type']).to eq 'ReturnInvoice'
          end
        end
      end
    end

    context 'with incorrect params' do
      context 'when transaction does not exist in avalara' do
        let(:params) { { order: order } }

        before { sales_transaction.update(code: 'testerror') }

        it 'returns error' do
          VCR.use_cassette('spree_avatax_official/transactions/get_by_code/error') do
            expect(subject.value['error']['code']).to eq 'EntityNotFoundError'
          end
        end
      end

      context 'when order transaction does not exist' do
        let(:params) { { order: create(:order) } }

        it 'returns error' do
          expect(subject.value).to eq I18n.t('spree_avatax_official.get_by_code_service.missing_code')
        end
      end
    end
  end
end
