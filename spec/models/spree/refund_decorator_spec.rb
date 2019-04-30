require 'spec_helper'

describe Spree::RefundDecorator do
  describe '#create', :avatax_enabled, if: defined?(Spree::Refund) do
    let(:refund) { create(:refund, amount: 10) }

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      refund
    end
  end
end
