require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::FullRefundPresenter do
  subject { described_class.new(order: order) }

  describe '#to_json' do
    let(:order) do
      create(:completed_order_with_totals).tap do |order|
        order.avatax_transactions.create(
          code:             'testcode',
          transaction_type: 'SalesInvoice'
        )
      end
    end

    let(:result) do
      {
        referenceCode: order.number,
        refundDate:    order.completed_at.strftime('%Y-%m-%d'),
        refundType:    'Full'
      }
    end

    it 'serializes the object' do
      expect(subject.to_json).to eq result
    end
  end
end
