require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::CreatePresenter do
  subject { described_class.new(order: order, ship_from_address: ship_from_address, transaction_type: transaction_type, transaction_code: '123') }

  describe '#to_json' do
    let(:order) { create(:order_with_line_items) }
    let(:ship_from_address) { create(:address) }
    let(:transaction_type) { 'SalesOrder' }

    let(:result) do
      {
        type: transaction_type,
        companyCode: SpreeAvataxOfficial::Configuration.new.company_code,
        code: '123',
        date: order.updated_at.strftime('%Y-%m-%d'),
        customerCode: order.email,
        addresses:
          SpreeAvataxOfficial::AddressPresenter.new(address: ship_from_address, address_type: 'ShipFrom').to_json.merge(
            SpreeAvataxOfficial::AddressPresenter.new(address: order.ship_address, address_type: 'ShipTo').to_json
          ),
        lines: order.line_items.map { |line_item| SpreeAvataxOfficial::LineItemPresenter.new(line_item: line_item).to_json },
        commit: false
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
