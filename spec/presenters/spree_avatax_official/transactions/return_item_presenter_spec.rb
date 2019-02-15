require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::ReturnItemPresenter, if: defined?(Spree::ReturnItem) do
  subject { described_class.new(return_item: return_item) }

  describe '#to_json' do
    let(:order) do
      create(:shipped_order, line_items_count: 2).tap do |order|
        order.avatax_transactions.create(
          code: 'testcode',
          transaction_type: 'SalesInvoice'
        )
      end
    end
    let(:inventory_unit) { order.inventory_units.first }
    let(:return_auth)    { create(:return_authorization, order: order) }
    let(:return_item)    { create(:return_item, return_authorization: return_auth, inventory_unit: inventory_unit)}

    let(:result) do
      {
        refundTransactionCode: 'testcode',
        referenceCode:         order.number,
        refundDate:            Time.zone.now.strftime('%Y-%m-%d'),
        refundType:            'Partial',
        refundLines:           [inventory_unit.line_item.avatax_number]
      }
    end

    before do
      # inventory units created with spree 2-2 factory do not have order assigned
      Spree::InventoryUnit.update_all(order_id: order.id)
    end

    context 'with partial refund' do
      it 'serializes the object' do
        expect(subject.to_json).to eq result
      end
    end

    context 'with full refund' do
      it 'serializes the object' do
        result[:refundType]  = 'Full'
        result[:refundLines] = nil

        order.inventory_units.last.destroy

        expect(subject.to_json).to eq result
      end
    end
  end
end
