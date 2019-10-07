require 'spec_helper'

describe SpreeAvataxOfficial::Utilities::PingService do
  subject { described_class.call }

  it 'respond with success' do
    VCR.use_cassette('spree_avatax_official/utilities/ping') do
      expect(subject.success?).to eq true
    end
  end
end
