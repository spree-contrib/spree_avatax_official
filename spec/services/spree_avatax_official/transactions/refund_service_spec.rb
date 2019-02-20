require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::RefundService do
  describe '#call' do
    subject { described_class.call(refundable: return_auth) }

    let(:order) { create(:shipped_order, line_items_count: 2) }
    let(:return_auth) { create(:return_authorization, order: order, inventory_units: order.inventory_units) }

    context 'with return authorization' do
      context 'with full refund' do
        it 'creates refund transaction' do
          expect(SpreeAvataxOfficial::Transactions::FullRefundService).to receive(:call)

          subject
        end
      end

      context 'with partial refund' do
        it 'creates refund only with refunded lines' do
          # inventory units created with spree 2-2 factory do not have order assigned
          Spree::InventoryUnit.update_all(order_id: order.id)

          return_auth.inventory_units = [order.inventory_units.first]

          expect(SpreeAvataxOfficial::Transactions::PartialRefundService).to receive(:call)

          subject
        end
      end
    end

    context 'with return item', if: defined?(Spree::ReturnItem) do
      let(:return_item) { create(:return_item, return_authorization: return_auth, inventory_unit: return_auth.inventory_units.first) }

      it 'creates refund transaction' do
        expect(SpreeAvataxOfficial::Transactions::PartialRefundService).to receive(:call)

        described_class.call(refundable: return_item)
      end
    end
  end
end
