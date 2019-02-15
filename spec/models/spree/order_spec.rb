require 'spec_helper'

describe Spree::Order do
  describe '#cancel' do
    let(:order) { create(:completed_order_with_totals) }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true

      example.run

      SpreeAvataxOfficial::Config.enabled = false
    end

    before do
      # spree-fullscript
      allow(Spree::OrderMailer).to receive_message_chain(:cancel_email, :deliver_now)
      # spree-3-1
      allow(Spree::OrderMailer).to receive_message_chain(:cancel_email, :deliver_later)
    end

    it 'calls void service' do
      order.create_avatax_sales_invoice_transaction

      expect(SpreeAvataxOfficial::Transactions::VoidService).to receive(:call)

      order.cancel
    end
  end

  describe '#avatax_sales_invoice_code' do
    let(:transaction) { create(:spree_avatax_official_transaction, transaction_type: 'SalesInvoice') }
    let(:order)       { transaction.order }

    it 'returns code of avatax sales invoice' do
      expect(order.avatax_sales_invoice_code).to eq transaction.code
    end
  end
end
