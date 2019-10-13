module SpreeAvataxOfficial
  module Utilities
    class PingService < SpreeAvataxOfficial::Base
      def call
        request_result(client.ping)
      end
    end
  end
end
