require 'spec_helper'

describe SpreeAvataxOfficial::Spree::RefundDecorator do
  describe '#create', :avatax_enabled do
    let(:refund) { create(:refund, amount: 10) }

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      refund
    end
  end
end
