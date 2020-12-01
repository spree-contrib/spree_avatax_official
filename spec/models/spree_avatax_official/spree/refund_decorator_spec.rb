require 'spec_helper'

describe SpreeAvataxOfficial::Spree::RefundDecorator do
  describe '#create', :avatax_enabled do
    let(:refund) { create(:refund, amount: 10) }

    context 'commit transaction enabled' do
      before do
        SpreeAvataxOfficial::Config.enabled = true
        SpreeAvataxOfficial::Config.commit_transaction_enabled = true
      end

      it 'calls refund service' do
        expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

        refund
      end
    end

    context 'commit transaction disabled' do
      before do
        SpreeAvataxOfficial::Config.enabled = false
        SpreeAvataxOfficial::Config.commit_transaction_enabled = false
      end

      it 'doesnt call refund service' do
        expect(SpreeAvataxOfficial::Transactions::RefundService).to_not receive(:call)

        refund
      end
    end
  end
end
