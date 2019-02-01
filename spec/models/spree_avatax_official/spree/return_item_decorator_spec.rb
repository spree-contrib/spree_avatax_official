require 'spec_helper'

describe SpreeAvataxOfficial::Spree::ReturnItemDecorator do
  describe '#receive', if: defined?(Spree::ReturnItem) do
    let(:return_item) { create(:return_item, reception_status: :awaiting, inventory_unit: create(:inventory_unit, state: :shipped)) }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true

      example.run

      SpreeAvataxOfficial::Config.enabled = false
    end

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      VCR.use_cassette('spree_order/refund_order') do
        return_item.receive!
      end
    end
  end
end
