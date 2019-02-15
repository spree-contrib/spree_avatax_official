require 'spec_helper'

describe SpreeAvataxOfficial::RefundDecorator do
  describe '#receive', unless: defined?(Spree::ReturnItem) do
    class Spree::ReturnAuthorization
      prepend SpreeAvataxOfficial::RefundDecorator
    end

    let(:order) { create(:shipped_order, state: :awaiting_return) }
    let(:return_authorization) { create(:return_authorization, order: order, inventory_units: order.inventory_units, state: :authorized) }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true

      example.run

      SpreeAvataxOfficial::Config.enabled = false
    end

    before { Spree::InventoryUnit.update_all(order_id: order.id) }

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      return_authorization.receive
    end
  end
end
