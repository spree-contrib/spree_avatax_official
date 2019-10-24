module SpreeAvataxOfficial
  module Utilities
    class PingService < SpreeAvataxOfficial::Base
      def call
        request_result(client.ping)
      rescue URI::InvalidURIError => e
        failure(e.message)
      end
    end
  end
end
