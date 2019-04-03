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
      logger.info("[AVATAX] #{object&.class}-#{object&.id} #{message.to_json}") if enabled?
    end

    def debug(object, message = '')
      logger.debug("[AVATAX] #{object.class}-#{object.id} #{message.to_json}") if enabled?
    end

    def error(object, message = '')
      logger.error("[AVATAX] #{object.class}-#{object.id} #{message.to_json}") if enabled?
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
  end
end
