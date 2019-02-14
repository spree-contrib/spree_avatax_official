require 'spec_helper'

describe Spree::Order do
  describe '#cancel' do
    let(:order) { create(:completed_order_with_totals) }

    around(:each) do |example|
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
end
