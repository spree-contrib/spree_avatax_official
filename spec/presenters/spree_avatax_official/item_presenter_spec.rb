require 'spec_helper'

describe SpreeAvataxOfficial::ItemPresenter do
  subject { described_class.new(item: item) }

  describe '#to_json' do
    context 'with line item' do
      let(:item) { create(:line_item) }

      let(:result) do
        {
          number:     "#{item.id}-LI",
          quantity:   item.quantity,
          amount:     item.discounted_amount,
          taxCode:    'P0000000',
          discounted: false
        }
      end

      context 'without line item tax code' do
        it 'serializes the object' do
          expect(subject.to_json).to eq result
        end
      end

      context 'with line item tax code' do
        it 'serializes the object' do
          item.tax_category.tax_code = 'P0000001'

          result[:taxCode] = 'P0000001'

          expect(subject.to_json).to eq result
        end
      end

      context 'with line item quantity' do
        subject { described_class.new(item: item, quantity: quantity) }

        let(:quantity) { item.quantity - 1 }

        it 'serializes the object' do
          result[:quantity] = quantity

          expect(subject.to_json).to eq result
        end
      end
    end

    context 'with shipment' do
      let(:item) { create(:shipment) }

      let(:result) do
        {
          number:     "#{item.id}-FR",
          quantity:   1,
          amount:     item.discounted_amount,
          taxCode:    'FR',
          discounted: false
        }
      end

      it 'serializes the object' do
        expect(subject.to_json).to eq result
      end
    end
  end
end
