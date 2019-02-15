require 'spec_helper'

describe Spree::LineItem do
  let(:line_item) { create(:line_item) }

  describe '#avatax_number' do
    it 'returns line item id with avatax code' do
      expect(line_item.avatax_number).to eq "#{line_item.id}-LI"
    end
  end
end
