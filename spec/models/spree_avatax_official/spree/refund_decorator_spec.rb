require 'spec_helper'

describe SpreeAvataxOfficial::Spree::RefundDecorator do
  describe '#create', if: defined?(Spree::Refund) do
    let(:refund) { create(:refund, amount: 10) }

    around do |example|
      SpreeAvataxOfficial::Config.enabled = true

      example.run

      SpreeAvataxOfficial::Config.enabled = false
    end

    it 'calls refund service' do
      expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

      refund
    end
  end
end
