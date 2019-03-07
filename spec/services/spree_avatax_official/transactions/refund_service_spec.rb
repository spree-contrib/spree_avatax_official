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

    context 'with refund', if: defined?(Spree::Refund) do
      let(:refund) { create(:refund, amount: 10, reimbursement: reimbursement) }
      let(:reimbursement) { create(:reimbursement) }

      context 'with full refund' do
        it 'creates refund transaction' do
          expect(SpreeAvataxOfficial::Transactions::FullRefundService).to receive(:call)

          described_class.call(refundable: refund)
        end
      end

      context 'with partial refund' do
        let(:order) do
          reimbursement.order.tap do |order|
            order.update(ship_address: create(:usa_address))
            create(:inventory_unit, order: order)
          end
        end
        let(:inventory_unit) do
          order.inventory_units.first.tap do |inventory_unit|
            inventory_unit.return_items.update_all(pre_tax_amount: 10)
          end
        end
        let(:line_item) do
          inventory_unit.line_item.tap do |line_item|
            line_item.update_columns(price: 100, quantity: 3, avatax_uuid: 'a844605f-e114-4933-a0cf-7a434ac83cdf')
          end
        end

        it 'creates refund only for refunded lines' do
          VCR.use_cassette('spree_avatax_official/transactions/refund/partial_refund_with_refund_success') do
            order.reload

            line = described_class.call(refundable: refund).value['lines'].first

            expect(line['lineAmount']).to eq 10
            expect(line['quantity']).to eq 1
          end
        end
      end
    end
  end
end
