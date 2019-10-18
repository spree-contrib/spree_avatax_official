require 'spec_helper'

describe SpreeAvataxOfficial::EntityUseCode do
  describe '.table_name' do
    subject { described_class.table_name }

    it      { is_expected.to eq 'spree_avatax_official_entity_use_codes' }
  end
end
