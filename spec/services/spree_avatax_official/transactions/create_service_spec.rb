require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::CreateService do
  describe '#call' do
    context 'with correct parameters' do
      let(:order) { create(:order_with_line_items, line_items_count: 1, ship_address: create(:usa_address)) }

      context 'for SalesOrder and Avalara API successful response' do
        subject { described_class.call(order: order) }

        it 'returns positive result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/sales_order_success') do
            result   = subject
            response = result.value

            expect(result.success?).to eq true
            expect(response['type']).to eq 'SalesOrder'
            expect(response['status']).to eq 'Temporary'
            expect(response['lines'].size).to eq 2
            expect(SpreeAvataxOfficial::Transaction.count).to eq 0
          end
        end
      end

      context 'for SalesInvoice and Avalara API successful response' do
        subject { described_class.call(order: order) }

        let(:order) { create(:order_with_line_items, line_items_count: 1, ship_address: create(:usa_address)) }

        it 'returns positive result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/invoice_order_success') do
            result   = subject
            response = result.value

            expect(result.success?).to eq true
            expect(response['type']).to eq 'SalesOrder'
            expect(response['status']).to eq 'Temporary'
            expect(response['lines'].size).to eq 2
          end
        end

        context 'with complete order' do
          it 'creates transaction with Committed status' do
            VCR.use_cassette('spree_avatax_official/transactions/create/complete_order_success') do
              order.update(state: :complete, completed_at: Time.current)

              result   = subject
              response = result.value

              expect(result.success?).to eq true
              expect(response['type']).to eq 'SalesInvoice'
              expect(response['status']).to eq 'Committed'
              expect(SpreeAvataxOfficial::Transaction.count).to eq 1
            end
          end
        end
      end

      context 'and Avalara API timeout' do
        subject do
          described_class.call(
            order:   order,
            options: { '$include' => 'ForceTimeout' }
          )
        end

        let(:connection_options) { { request: { timeout: 120.0, open_timeout: 120.0 } } }

        before do
          allow_any_instance_of(AvaTax::Client).to receive(:connection_options).and_return(connection_options) # rubocop:disable RSpec/AnyInstance
        end

        it 'returns negative result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/timeout') do
            result   = subject
            response = result.value

            expect(result.success?).to eq false
            expect(response['error']).to be_present
            expect(response['error']['code']).to eq 'TimeoutRequested'
          end
        end
      end

      context 'and Faraday read timeout' do
        subject { described_class.call(order: order) }

        let(:connection_options) { { request: { timeout: 0, open_timeout: 2 } } }

        before do
          allow_any_instance_of(AvaTax::Client).to receive(:connection_options).and_return(connection_options) # rubocop:disable RSpec/AnyInstance
        end

        it 'returns negative result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/faraday_read_timeout') do
            result   = subject
            response = result.value

            expect(result.success?).to eq false
            expect(response['error']).to be_present
            expect(response['error']['code']).to eq 'ConnectionError'
            expect(response['error']['message']).to eq 'Faraday::TimeoutError - Net::ReadTimeout'
          end
        end
      end

      context 'and Faraday open timeout' do
        subject { described_class.call(order: order) }

        let(:connection_options) { { request: { timeout: 6, open_timeout: 0 } } }

        before do
          allow_any_instance_of(AvaTax::Client).to receive(:connection_options).and_return(connection_options) # rubocop:disable RSpec/AnyInstance
        end

        it 'returns negative result' do
          VCR.use_cassette('spree_avatax_official/transactions/create/faraday_open_timeout') do
            result   = subject
            response = result.value

            expect(result.success?).to eq false
            expect(response['error']).to be_present
            expect(response['error']['code']).to eq 'ConnectionError'
            expect(response['error']['message']).to eq 'Faraday::ConnectionFailed - Net::OpenTimeout'
          end
        end
      end
    end

    context 'with incorrect parameters' do
      subject { described_class.call(order: order_without_line_items) }

      let(:order_without_line_items) { create(:order, ship_address: create(:usa_address)) }

      it 'returns negative result' do
        VCR.use_cassette('spree_avatax_official/transactions/create/failure') do
          result = subject

          expect(result.success?).to eq false
        end
      end
    end
  end
end
