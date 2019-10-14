require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::CreatePresenter do
  subject { described_class.new(order: order, transaction_type: transaction_type) }

  describe '#to_json' do
    let(:order) { create(:order_with_line_items) }
    let(:order_items) { order.taxable_items }
    let(:ship_from_address) { SpreeAvataxOfficial::Config.ship_from_address }
    let(:transaction_type) { 'SalesOrder' }

    let(:result) do
      {
        type:            transaction_type,
        companyCode:     SpreeAvataxOfficial::Configuration.new.company_code,
        code:            order.number,
        referenceCode:   order.number,
        date:            order.updated_at.strftime('%Y-%m-%d'),
        customerCode:    order.email,
        addresses:       SpreeAvataxOfficial::AddressPresenter.new(address: ship_from_address, address_type: 'ShipFrom').to_json.merge(
          SpreeAvataxOfficial::AddressPresenter.new(address: order.ship_address, address_type: 'ShipTo').to_json
        ),
        lines:           order_items.map { |item| SpreeAvataxOfficial::ItemPresenter.new(item: item).to_json },
        commit:          false,
        discount:        0.0,
        currencyCode:    order.currency,
        purchaseOrderNo: order.number,
        entityUseCode:   order.try(:user).try(:spree_avatax_official_entity_use_codes_id)
      }
    end

    context 'with incomplete order' do
      it 'serializes the object' do
        expect(subject.to_json).to eq result
      end
    end

    context 'with complete order' do
      before { order.update(completed_at: Time.current) }

      it 'serializes the object' do
        order.update(state: :complete)

        result[:commit] = true

        expect(subject.to_json).to eq result
      end

      context 'with complete order awaiting return' do
        it 'serializes the object' do
          order.update(state: :awaiting_return)

          result[:commit] = true

          expect(subject.to_json).to eq result
        end
      end
    end

    context 'with company code', if: defined?(Spree::Store) do
      it 'serializes the object' do
        order.update(store: create(:store, avatax_company_code: 'test123'))

        result[:companyCode] = 'test123'

        expect(subject.to_json).to eq result
      end
    end

    context 'with custom transaction code' do
      subject { described_class.new(order: order, transaction_type: transaction_type, transaction_code: 'test-code') }

      it 'serializes the object' do
        result[:code] = 'test-code'

        expect(subject.to_json).to eq result
      end
    end

    context 'with user email' do
      let(:email) { 'user_email@test.com' }

      it 'serializes the object' do
        order.user.update(email: email)

        result[:customerCode] = email

        expect(subject.to_json).to eq result
      end
    end

    context 'without order currency' do
      it 'serializes the object' do
        order.currency = nil

        result[:currencyCode] = Spree::Config[:currency]

        expect(subject.to_json).to eq result
      end
    end
  end
end
