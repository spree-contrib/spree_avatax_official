require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::RefundPresenter do
  subject { described_class.new(return_authorization: return_auth) }

  describe '#to_json' do
    let(:order) do
      create(:shipped_order, line_items_count: 2).tap do |order|
        # TODO replace it with transaction factory
        # after relevant PR is merged
        SpreeAvataxOfficial::Transaction.create(
          order: order,
          code: 'testcode',
          transaction_type: 'SalesInvoice'
        )
      end
    end
    let(:return_auth) { create(:return_authorization, order: order) }

    let(:result) do
      {
        refundTransactionCode: 'testcode',
        referenceCode:         order.number,
        refundDate:            Time.zone.now.strftime('%Y-%m-%d'),
        refundType:            'Full'
      }
    end

    before do
      # inventory units created with spree 2-2 factory do not have order assigned
      Spree::InventoryUnit.update_all(order_id: order.id)
    end

    context 'with partial refund' do
      it 'serializes the object' do
        inventory_unit              = order.inventory_units.first
        return_auth.inventory_units = [inventory_unit]
        result[:refundType]         = 'Partial'
        result[:refundLines]        = [inventory_unit.variant.sku]

        expect(subject.to_json).to eq result
      end
    end

    context 'with full refund' do
      it 'serializes the object' do
        return_auth.inventory_units = order.inventory_units

        expect(subject.to_json).to eq result
      end
    end
  end
end
