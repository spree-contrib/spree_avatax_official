require 'spec_helper'

describe SpreeAvataxOfficial::TaxAdjustmentLabelHelper do
  describe '#tax_adjustment_label' do
    context 'with SpreeAvatxOfficial::Config.show_rate_in_label equal true' do
      around do |example|
        SpreeAvataxOfficial::Config.show_rate_in_label = true
        example.run
        SpreeAvataxOfficial::Config.show_rate_in_label = false
      end

      context 'with line item as first parameter' do
        let(:line_item) { create(:line_item) }

        it 'returns Sales Tax string' do
          expect(helper.tax_adjustment_label(line_item, 0.08)).to eq 'Sales Tax (8%)'
        end
      end

      context 'with shipments as first parameter' do
        let(:shipment) { create(:shipment) }

        it 'returns Shipping Tax string' do
          expect(helper.tax_adjustment_label(shipment, 0.08)).to eq 'Shipping Tax (8%)'
        end
      end
    end
  end

  describe '#format_adjustment_label' do
    context 'with SpreeAvatxOfficial::Config.show_rate_in_label equal true' do
      around do |example|
        SpreeAvataxOfficial::Config.show_rate_in_label = true
        example.run
        SpreeAvataxOfficial::Config.show_rate_in_label = false
      end

      context 'when rate has trailing zeros' do
        it 'returns percent value without trailing zeros' do
          expect(helper.format_adjustment_label('Text', 0.04000)).to eq 'Text (4%)'
        end
      end

      context 'when rates has multiple decimal digits' do
        it 'returns percent value with digits after .' do
          expect(helper.format_adjustment_label('Text', 0.04123)).to eq 'Text (4.123%)'
        end
      end
    end
  end
end
