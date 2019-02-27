require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::AdjustPresenter do
  subject do
    described_class.new(
      order:                  order,
      adjustment_reason:      'PriceAdjusted',
      adjustment_description: 'Adjustment description'
    )
  end

  describe '#to_json' do
    let(:order) { create(:order_with_line_items) }

    let(:transaction_type) { 'SalesInvoice' }
    let!(:invoice_transaction) do
      create(
        :spree_avatax_official_transaction,
        transaction_type: transaction_type,
        order:            order
      )
    end

    let(:result) do
      {
        adjustmentReason:      'PriceAdjusted',
        adjustmentDescription: 'Adjustment description',
        newTransaction:        SpreeAvataxOfficial::Transactions::CreatePresenter.new(
          order:            order,
          transaction_type: transaction_type,
          transaction_code: invoice_transaction.code
        ).to_json
      }
    end

    it 'serializes the object' do
      expect(subject.to_json).to eq result
    end
  end
end
