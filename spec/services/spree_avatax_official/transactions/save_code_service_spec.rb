require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::SaveCodeService do
  subject { described_class.call(code: 'test123', order: create(:order), type: 'SalesInvoice') }

  describe '#call' do
    it 'creates new transaction' do
      expect { subject }.to change { SpreeAvataxOfficial::Transaction.count }.by(1)
    end
  end
end
