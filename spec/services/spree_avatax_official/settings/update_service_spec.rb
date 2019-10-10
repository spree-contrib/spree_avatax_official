require 'spec_helper'

describe SpreeAvataxOfficial::Settings::UpdateService do
  describe '#call' do
    let(:subject) { described_class.call(params: params) }

    context 'company_code' do
      let(:params) { { company_code: 'test company code' } }

      around do |example|
        company_code = SpreeAvataxOfficial::Config.company_code
        example.run
        SpreeAvataxOfficial::Config.company_code = company_code
      end

      it 'updates company_code' do
        expect { subject }.to change { SpreeAvataxOfficial::Config.company_code }.to('test company code')
      end
    end

    context 'account_number' do
      let(:params) { { account_number: 'test account number' } }

      around do |example|
        account_number = SpreeAvataxOfficial::Config.account_number
        example.run
        SpreeAvataxOfficial::Config.account_number = account_number
      end

      it 'updates account_number' do
        expect { subject }.to change { SpreeAvataxOfficial::Config.account_number }.to('test account number')
      end
    end

    context 'license_key' do
      let(:params) { { license_key: 'test license key' } }

      around do |example|
        license_key = SpreeAvataxOfficial::Config.license_key
        example.run
        SpreeAvataxOfficial::Config.license_key = license_key
      end

      it 'updates license_key' do
        expect { subject }.to change { SpreeAvataxOfficial::Config.license_key }.to('test license key')
      end
    end

    context 'enabled' do
      around do |example|
        enabled = SpreeAvataxOfficial::Config.enabled
        example.run
        SpreeAvataxOfficial::Config.enabled = enabled
      end

      context 'when enabled param is true' do
        let(:params) { { enabled: 'true' } }

        it 'updates enabled to true' do
          SpreeAvataxOfficial::Config.enabled = false
          expect { subject }.to change { SpreeAvataxOfficial::Config.enabled }.to(true)
        end
      end

      context 'when enabled param is false' do
        let(:params) { { enabled: 'false' } }

        it 'updates enabled to false' do
          SpreeAvataxOfficial::Config.enabled = true
          expect { subject }.to change { SpreeAvataxOfficial::Config.enabled }.to(false)
        end
      end
    end

    context 'ship_from_address' do
      let(:params) do
        {
          ship_from: {
            line1:       'test address',
            line2:       '',
            city:        'Chicago',
            country:     'USA',
            postal_code: '12345'
          }
        }
      end

      around do |example|
        ship_from = SpreeAvataxOfficial::Config.ship_from_address
        example.run
        SpreeAvataxOfficial::Config.ship_from_address = ship_from
      end

      it 'updates ship_from_address' do
        expect { subject }.to  change { SpreeAvataxOfficial::Config.ship_from_address[:line1] }.to('test address')
                          .and change { SpreeAvataxOfficial::Config.ship_from_address[:city] }.to('Chicago')
                          .and change { SpreeAvataxOfficial::Config.ship_from_address[:postalCode] }.to('12345')
      end
    end
  end
end
