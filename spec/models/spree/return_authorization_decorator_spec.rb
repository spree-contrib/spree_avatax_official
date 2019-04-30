require 'spec_helper'

describe Spree::ReturnAuthorizationDecorator, :vcr do
  describe '#receive', :avatax_enabled, unless: defined?(Spree::ReturnItem) do
    let(:order)                { create(:avatax_order, :shipped, state: :awaiting_return, number: 'R864478595') }
    let(:return_authorization) { create(:return_authorization, order: order, inventory_units: order.inventory_units, state: :authorized) }

    before { Spree::InventoryUnit.update_all(order_id: order.id) }

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      return_authorization.receive!
    end
  end
end
