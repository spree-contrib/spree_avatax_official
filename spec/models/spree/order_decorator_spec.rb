require 'spec_helper'

describe Spree::Order do
  describe 'associations' do
    let(:order) { create(:order) }

    describe 'avatax_sales_order_transaction' do
      let!(:sales_order_transaction) { create(:spree_avatax_official_transaction, order: order, transaction_type: 'SalesOrder') }
      let!(:sales_invoice_transaction) { create(:spree_avatax_official_transaction, order: order, transaction_type: 'SalesInvoice') }

      it 'returns SpreeAvataxOfficial::Transaction object with transaction_type: SalesOrder' do
        expect(order.avatax_sales_order_transaction).to eq sales_order_transaction
      end
    end

    describe 'avatax_sales_invoice_transaction' do
      let!(:sales_order_transaction) { create(:spree_avatax_official_transaction, order: order, transaction_type: 'SalesOrder') }
      let!(:sales_invoice_transaction) { create(:spree_avatax_official_transaction, order: order, transaction_type: 'SalesInvoice') }

      it 'returns SpreeAvataxOfficial::Transaction object with transaction_type: SalesInvoice' do
        expect(order.avatax_sales_invoice_transaction).to eq sales_invoice_transaction
      end
    end
  end
end
