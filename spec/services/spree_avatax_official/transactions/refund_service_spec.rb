require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::RefundService do
  describe '#call' do
    let(:subject)     { described_class.call(refund_object: return_auth) }
    let(:return_auth) { create(:return_authorization, order: order, inventory_units: order.inventory_units) }

    before { SpreeAvataxOfficial::Config.company_code = 'test1' }

    context 'with commited order' do
      let(:order) { create(:shipped_order, number: 'REFUNDTEST1') }

      it 'creates refund transaction' do
        VCR.use_cassette('spree_avatax_official/transactions/refund/success') do
          result = subject
          response = result.value

          expect(result.success?).to eq true
          expect(response['type']).to eq 'ReturnInvoice'
          expect(SpreeAvataxOfficial::Transaction.count).to eq 1
          expect(SpreeAvataxOfficial::Transaction.last.transaction_type).to eq 'ReturnInvoice'
        end
      end

      context 'with partial refund' do
        let(:order) { create(:shipped_order, number: 'REFUNDTEST321', line_items_count: 2) }

        it 'creates refund only with refunded lines' do
          # inventory units created with spree 2-2 factory do not have order assigned
          Spree::InventoryUnit.update_all(order_id: order.id)

          inventory_unit              = order.inventory_units.first
          variant                     = inventory_unit.variant
          return_auth.inventory_units = [inventory_unit]

          variant.update(sku: 'SKU-1')

          VCR.use_cassette('spree_avatax_official/transactions/refund/partial_refund_success') do
            result   = subject
            response = result.value

            expect(result.success?).to eq true
            expect(response['lines'].count).to eq 1
            expect(response['lines'].first['lineNumber']).to eq variant.sku
          end
        end
      end
    end

    context 'with uncomitted order' do
      let(:order) { create(:shipped_order, number: 'REFUNDTEST456') }

      it 'returns error' do
        VCR.use_cassette('spree_avatax_official/transactions/refund/error') do
          result = subject
          response = result.value

          expect(result.failure?).to eq true
          expect(response['error']['code']).to eq 'InvalidDocumentStatusForRefund'
          expect(SpreeAvataxOfficial::Transaction.count).to eq 0
        end
      end
    end

    context 'with return item', if: defined?(Spree::ReturnItem) do
      let(:order)       { create(:shipped_order, number: 'REFUNDITEM') }
      let(:return_item) { create(:return_item, return_authorization: return_auth, inventory_unit: return_auth.inventory_units.first) }

      it 'creates refund transaction' do
        VCR.use_cassette('spree_avatax_official/transactions/refund/return_item_success') do
          result   = described_class.call(refund_object: return_item)
          response = result.value

          expect(result.success?).to eq true
          expect(response['type']).to eq 'ReturnInvoice'
          expect(SpreeAvataxOfficial::Transaction.count).to eq 1
          expect(SpreeAvataxOfficial::Transaction.last.transaction_type).to eq 'ReturnInvoice'
        end
      end
    end
  end
end
