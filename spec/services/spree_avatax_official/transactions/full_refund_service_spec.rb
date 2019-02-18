require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::FullRefundService do
  describe '#call' do
    subject { described_class.call(order: order) }

    let(:order) do
      create(:completed_order_with_totals).tap do |order|
        order.avatax_transactions.create(
          code:             'TESTFULLREFUND',
          transaction_type: 'SalesInvoice'
        )
      end
    end

    it 'creates refund transaction' do
      VCR.use_cassette('spree_avatax_official/transactions/refund/full_refund_success') do
        result   = subject
        response = result.value

        expect(result.success?).to eq true
        expect(response['type']).to eq 'ReturnInvoice'
        expect(SpreeAvataxOfficial::Transaction.count).to eq 2
        expect(SpreeAvataxOfficial::Transaction.last.transaction_type).to eq 'ReturnInvoice'
      end
    end
  end
end
