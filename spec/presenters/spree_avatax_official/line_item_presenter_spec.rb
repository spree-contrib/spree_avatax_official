require 'spec_helper'

describe SpreeAvataxOfficial::LineItemPresenter do
  subject { described_class.new(line_item: line_item) }

  describe '#to_json' do
    let(:line_item) { create(:line_item) }

    let(:result) do
      {
        number: line_item.variant.sku,
        quantity: line_item.quantity,
        amount: line_item.amount
      }
    end

    it 'serializes the object' do
      expect(subject.to_json).to eq result
    end
  end
end
