require 'spec_helper'

describe SpreeAvataxOfficial::HasUuid do
  class Spree::LineItem
    include ::SpreeAvataxOfficial::HasUuid
  end

  let(:line_item) { create(:line_item) }

  describe '#avatax_uuid' do
    it 'generates uuid for new instance' do
      expect(line_item.avatax_uuid).not_to be_nil
    end
  end

  describe '#avatax_number' do
    it 'return uuid with avatax code' do
      expect(line_item.avatax_number).to eq "LI-#{line_item.avatax_uuid}"
    end
  end
end
