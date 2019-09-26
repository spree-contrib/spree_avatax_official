require 'spec_helper'

describe SpreeAvataxOfficial::AvataxLog, type: :model do
  let(:file_name)       { 'test_file.log' }
  let(:logger)          { described_class.new }
  let(:example_payload) { { test: 'Test!' } }
  let!(:order)          { create(:order) }

  before do
    SpreeAvataxOfficial::Config.log_file_name = file_name
    SpreeAvataxOfficial::Config.log_to_stdout = false
    SpreeAvataxOfficial::Config.log           = true
  end

  describe '#enabled?' do
    it 'returns a boolean value' do
      SpreeAvataxOfficial::Config.log = true

      expect(logger).to be_enabled
    end
  end

  describe '#info' do
    it 'logs info with given message' do
      logger.info(example_payload)

      expect(File.new(Rails.root.join('log', file_name)).read).to include "[AVATAX] - #{example_payload.to_json}"
    end

    it 'returns nil if logger is not enabled' do
      SpreeAvataxOfficial::Config.log = false

      expect(logger.info('this_wont_change')).to be_nil
    end

    context 'STDOUT' do
      before do
        SpreeAvataxOfficial::Config.log_to_stdout = true
      end

      it 'writes logs to STDOUT' do
        expect { logger.info('Test!') }.to output.to_stdout_from_any_process
      end
    end
  end

  describe '#debug' do
    it 'receives debug with message' do
      logger.debug(order, example_payload)

      expect(File.new(Rails.root.join('log', file_name)).read).to include "[AVATAX] #{order.class}-#{order.id} #{example_payload.to_json}"
    end

    it 'returns nil if logger is not enabled' do
      SpreeAvataxOfficial::Config.log = false

      expect(logger.debug(['Test!'])).to be_nil
    end
  end

  describe '#error' do
    it 'logs error with given message' do
      logger.error(order, example_payload)

      expect(File.new(Rails.root.join('log', file_name)).read).to include "[AVATAX] #{order.class}-#{order.id} #{example_payload.to_json}"
    end

    it 'returns nil if logger is not enabled' do
      SpreeAvataxOfficial::Config.log = false

      expect(logger.error('this_wont_change')).to be_nil
    end

    context 'message with status and body' do
      it 'logs error with given message' do
        message         = Struct.new(:message, :status, :body)
        example_payload = message.new(400, test: 'Test!')
        log_data        = "[AVATAX] #{order.class}-#{order.id} #{example_payload.status} #{example_payload.body.to_json}"

        logger.error(order, example_payload)
        expect(File.new(Rails.root.join('log', file_name)).read).to include log_data
      end
    end
  end
end
