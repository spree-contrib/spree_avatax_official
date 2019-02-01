require 'spec_helper'

describe SpreeAvataxOfficial::LineItemPresenter do
  subject { described_class.new(line_item: line_item) }

  describe '#to_json' do
    let(:line_item) { create(:line_item) }

    let(:result) do
      {
        number: line_item.variant.sku,
        quantity: line_item.quantity,
        amount: line_item.amount,
        taxCode: 'P0000000'
      }
    end

    context 'without line item tax code' do
      it 'serializes the object' do
        expect(subject.to_json).to eq result
      end
    end

    context 'with line item tax code' do
      it 'serializes the object' do
        line_item.tax_category.tax_code = 'P0000001'

        result[:taxCode] = 'P0000001'

        expect(subject.to_json).to eq result
      end
    end
  end
end
