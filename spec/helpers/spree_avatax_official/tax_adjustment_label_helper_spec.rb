require 'spec_helper'

describe SpreeAvataxOfficial::TaxAdjustmentLabelHelper do
  describe '#tax_adjustment_label' do
    let(:subject) { helper.tax_adjustment_label(item, 0.08) }

    context 'with SpreeAvatxOfficial::Config.show_rate_in_label equal true' do
      before { SpreeAvataxOfficial::Config.show_rate_in_label = true }

      context 'with tax included in price' do
        before do
          allow(item).to receive(:included_in_price).and_return true
        end

        context 'with line item as first parameter' do
          let(:item) { create(:line_item) }

          it 'returns Sales Included Tax string' do
            expect(subject).to eq 'Sales Included Tax (8%)'
          end
        end

        context 'with shipments as first parameter' do
          let(:item) { create(:shipment) }

          it 'returns Shipping Included Tax string' do
            expect(subject).to eq 'Shipping Included Tax (8%)'
          end
        end
      end

      context 'with tax excluded' do
        before do
          allow(item).to receive(:included_in_price).and_return false
        end

        context 'with line item as first parameter' do
          let(:item) { create(:line_item) }

          it 'returns Sales Tax string' do
            expect(subject).to eq 'Sales Tax (8%)'
          end
        end

        context 'with shipments as first parameter' do
          let(:item) { create(:shipment) }

          it 'returns Shipping Tax string' do
            expect(subject).to eq 'Shipping Tax (8%)'
          end
        end
      end
    end
  end

  describe '#format_adjustment_label' do
    context 'with SpreeAvatxOfficial::Config.show_rate_in_label equal true' do
      before { SpreeAvataxOfficial::Config.show_rate_in_label = true }

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
