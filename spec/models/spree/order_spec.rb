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

  describe '#cancel' do
    let!(:avatax_tax_rate) { create(:avatax_tax_rate) }
    let(:order) { create(:order, ship_address: create(:usa_address)) }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true
      example.run
      SpreeAvataxOfficial::Config.enabled = false
    end

    before do
      VCR.use_cassette('spree_order/simple_order_with_single_line_item') do
        create(:line_item, id: 1, price: 10.0, quantity: 1, order: order)
        order.update(state: :complete, completed_at: Time.current)
      end

      # spree-fullscript
      allow(Spree::OrderMailer).to receive_message_chain(:cancel_email, :deliver_now)
      # spree-3-1
      allow(Spree::OrderMailer).to receive_message_chain(:cancel_email, :deliver_later)
    end

    it 'calls void service' do
      order.create_avatax_sales_invoice_transaction

      expect(SpreeAvataxOfficial::Transactions::VoidService).to receive(:call)

      VCR.use_cassette('spree_order/avatax_cancel_order') do
        order.cancel
      end
    end
  end

  describe '#taxable_items' do
    let(:order) { create(:shipped_order, line_items_count: 2) }

    it 'returns array of shipments and line items' do
      expect(order.taxable_items).to eq [order.line_items.first, order.line_items.last, order.shipments.first]
    end
  end

  describe '#avatax_sales_invoice_code' do
    let(:transaction) { create(:spree_avatax_official_transaction, transaction_type: 'SalesInvoice') }
    let(:order)       { transaction.order }

    it 'returns code of avatax sales invoice' do
      expect(order.avatax_sales_invoice_code).to eq transaction.code
    end
  end

  describe 'tax estimation triggering' do
    let!(:avatax_tax_rate) { create(:avatax_tax_rate) }
    let(:order) { create(:order, ship_address: create(:usa_address)) }
    let(:line_item) { order.line_items.first }
    let(:tax_adjustment) { line_item.adjustments.tax.first }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true
      example.run
      SpreeAvataxOfficial::Config.enabled = false
    end

    before do
      VCR.use_cassette('spree_order/simple_order_with_single_line_item') do
        create(:line_item, id: 1, price: 10.0, quantity: 1, order: order)

        order.updater.update
      end
    end

    context 'when line item discount promotion is applied' do
      let(:promotion) { create(:promotion, :with_line_item_adjustment, adjustment_rate: 5, code: 'promotion_code') }

      it 'triggers tax estimation' do
        expect(order.total).to eq 10.8

        VCR.use_cassette('spree_order/order_with_line_item_adjustment') do
          order.coupon_code = promotion.code
          Spree::PromotionHandler::Coupon.new(order).apply

          order.updater.update
        end

        expect(order.total).to eq 5.4
        expect(line_item.reload.total).to eq 5.4
        expect(tax_adjustment.amount).to eq 0.4
      end
    end

    context 'when order discount promotion is applied' do
      let(:promotion) { create(:promotion, :avatax_with_order_adjustment, weighted_order_adjustment_amount: 5.0, code: 'promotion_code') }

      it 'triggers tax estimation' do
        expect(order.total).to eq 10.8

        VCR.use_cassette('spree_order/order_with_order_adjustment') do
          order.coupon_code = promotion.code
          Spree::PromotionHandler::Coupon.new(order).apply

          order.updater.update
        end

        expect(order.total).to eq 5.4
        expect(line_item.reload.total).to eq 10.4
        expect(tax_adjustment.amount).to eq 0.4
      end
    end

    # TODO: Implement tax recalculation on tax address change and unxit this spec
    xcontext 'when shipping address is changed' do
      let(:california_address) { create(:usa_address, :from_california) }

      it 'triggers tax estimation' do
        expect(order.total).to eq 10.8

        VCR.use_cassette('spree_order/california_order') do
          order.update(ship_address: california_address)
        end

        expect(order.total).not_to eq 10.73
        expect(line_item.reload.total).to eq 10.73
        expect(tax_adjustment.amount).to eq 0.73
      end
    end
  end
end
