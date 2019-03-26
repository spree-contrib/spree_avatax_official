require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::CreatePresenter do
  subject { described_class.new(order: order, transaction_type: transaction_type, transaction_code: '123') }

  describe '#to_json' do
    let(:order) { create(:order_with_line_items) }
    let(:order_items) { order.taxable_items }
    let(:ship_from_address) { SpreeAvataxOfficial::Config.ship_from_address }
    let(:transaction_type) { 'SalesOrder' }

    let(:result) do
      {
        type:          transaction_type,
        companyCode:   SpreeAvataxOfficial::Configuration.new.company_code,
        code:          '123',
        referenceCode: order.number,
        date:          order.updated_at.strftime('%Y-%m-%d'),
        customerCode:  order.email,
        addresses:     SpreeAvataxOfficial::AddressPresenter.new(address: ship_from_address, address_type: 'ShipFrom').to_json.merge(
          SpreeAvataxOfficial::AddressPresenter.new(address: order.ship_address, address_type: 'ShipTo').to_json
        ),
        lines:         order_items.map { |item| SpreeAvataxOfficial::ItemPresenter.new(item: item).to_json },
        commit:        false,
        discount:      0.0
      }
    end

    context 'with incomplete order' do
      it 'serializes the object' do
        expect(subject.to_json).to eq result
      end
    end

    context 'with complete order' do
      it 'serializes the object' do
        order.update(state: :complete)

        result[:commit] = true

        expect(subject.to_json).to eq result
      end
    end

    context 'with company code', if: defined?(Spree::Store) do
      it 'serializes the object' do
        order.update(store: create(:store, avatax_company_code: 'test123'))

        result[:companyCode] = 'test123'

        expect(subject.to_json).to eq result
      end
    end
  end
end
