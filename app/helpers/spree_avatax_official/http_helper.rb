module SpreeAvataxOfficial
  module HttpHelper
    CONNECTION_ERRORS = [
      Faraday::TimeoutError, Faraday::ConnectionFailed, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED,
      EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
    ].freeze

    def mock_error_response(error)
      {
        'error' => {
          'code'    => 'ConnectionError',
          'message' => "#{error.class} - #{error.message}"
        }
      }
    end
  end
end
