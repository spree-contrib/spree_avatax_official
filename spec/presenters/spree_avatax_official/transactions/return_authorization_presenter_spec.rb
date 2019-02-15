require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::ReturnAuthorizationPresenter do
  subject { described_class.new(return_authorization: return_auth) }

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
    let(:return_auth) { create(:return_authorization, order: order) }

    let(:result) do
      {
        refundTransactionCode: 'testcode',
        referenceCode:         order.number,
        refundDate:            Time.zone.now.strftime('%Y-%m-%d'),
        refundType:            'Partial',
        refundLines:           [inventory_unit.variant.sku]
      }
    end

    before do
      # inventory units created with spree 2-2 factory do not have order assigned
      Spree::InventoryUnit.update_all(order_id: order.id)
    end

    context 'with partial refund' do
      it 'serializes the object' do
        return_auth.inventory_units = [inventory_unit]
        result[:refundType]         = 'Partial'
        result[:refundLines]        = [inventory_unit.line_item.avatax_number]

        expect(subject.to_json).to eq result
      end
    end

    context 'with full refund' do
      it 'serializes the object' do
        return_auth.inventory_units = order.inventory_units
        result[:refundType]  = 'Full'
        result[:refundLines] = nil

        expect(subject.to_json).to eq result
      end
    end
  end
end
