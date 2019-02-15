require 'spec_helper'

describe SpreeAvataxOfficial::Transaction do
  describe '.table_name' do
    subject { described_class.table_name }

    it      { is_expected.to eq 'spree_avatax_official_transactions' }
  end
end
