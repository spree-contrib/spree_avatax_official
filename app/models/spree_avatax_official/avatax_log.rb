module SpreeAvataxOfficial
  class AvataxLog
    LOG_DIRECTORY = 'log'.freeze

    def initialize
      @logger = Logger.new(*logger_params)
    end

    def enabled?
      SpreeAvataxOfficial::Config.log || SpreeAvataxOfficial::Config.log_to_stdout
    end

    def info(message, object = nil)
      logger.info(log_data(message, object)) if enabled?
    end

    def debug(object, message = '')
      logger.debug(log_data(message, object)) if enabled?
    end

    def error(object, message = '')
      logger.error(log_data(message, object)) if enabled?
    end

    delegate :log_file_name, :log_frequency, to: 'SpreeAvataxOfficial::Config'

    private

    attr_reader :logger

    def log_file_path
      Rails.root.join(LOG_DIRECTORY, log_file_name)
    end

    def logger_params
      return [STDOUT] if SpreeAvataxOfficial::Config.log_to_stdout

      [log_file_path, log_frequency]
    end

    def log_data(message, object)
      "[AVATAX] #{object&.class}-#{object&.id} #{log_message(message)}"
    end

    def log_message(message)
      return message.to_json unless message.respond_to?(:status)

      "#{message.status} #{message.body.to_json}"
    end
  end
end
