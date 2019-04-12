require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::RefundService do
  describe '#call' do
    subject { described_class.call(refundable: return_auth) }

    let(:order)       { create(:shipped_order, line_items_count: 2, ship_address: create(:usa_address)) }
    let(:return_auth) { create(:return_authorization, order: order, inventory_units: order.inventory_units) }

    context 'with return authorization', unless: defined?(Spree::Refund) do
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
      let(:payment)       { create(:payment, state: :completed, order: order) }
      let(:reimbursement) { order.reimbursements.create }
      let(:refund)        { create(:refund, amount: 10, reimbursement: reimbursement, payment: payment) }

      context 'with full refund' do
        it 'creates refund transaction' do
          order.inventory_units.each do |inventory_unit|
            reimbursement.return_items.create(inventory_unit: inventory_unit)
          end

          expect(SpreeAvataxOfficial::Transactions::FullRefundService).to receive(:call)

          described_class.call(refundable: refund)
        end
      end

      context 'with partial refund' do
        let(:inventory_unit) { order.inventory_units.first }

        before do
          reimbursement.return_items.create!(
            inventory_unit:    inventory_unit,
            pre_tax_amount:    10,
            acceptance_status: 'accepted'
          )
          order.update(completed_at: Time.current)
        end

        it 'creates refund only for refunded lines' do
          VCR.use_cassette('spree_avatax_official/transactions/refund/partial_refund_with_refund_success') do
            order.reload

            line = described_class.call(refundable: refund).value['lines'].first

            expect(line['lineAmount']).to eq(-10)
            expect(line['quantity']).to eq 1
          end
        end

        context 'line_item_quantity' do
          let(:params)       { { order: order, transaction_code: "#{order.number}-#{refund.id}", refund_items: refund_items } }
          let(:refund_items) { { inventory_unit.line_item => [inventory_unit.try(:quantity) || 1, -10] } }

          it 'calls partial service with correct quantity' do
            inventory_unit.update(quantity: 5) if inventory_unit.respond_to?(:quantity)

            expect(SpreeAvataxOfficial::Transactions::PartialRefundService).to receive(:call).with(params)

            described_class.call(refundable: refund)
          end
        end
      end
    end
  end
end
