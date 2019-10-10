require 'spec_helper'

describe SpreeAvataxOfficial::Spree::RefundDecorator do
  describe '#create', :avatax_enabled do
    let(:refund) { create(:refund, amount: 10) }

    context 'commit transaction enabled' do
      it 'calls refund service' do
        expect(SpreeAvataxOfficial::Transactions::RefundService).to receive(:call)

        refund
      end
    end

    context 'commit transaction disabled' do
      around do |example|
        SpreeAvataxOfficial::Config.commit_transaction_enabled = false
        example.run
        SpreeAvataxOfficial::Config.commit_transaction_enabled = true
      end

      it 'doesnt call refund service' do
        expect(SpreeAvataxOfficial::Transactions::RefundService).to_not receive(:call)

        refund
      end
    end
  end
end
