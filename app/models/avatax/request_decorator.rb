module Avatax
  module RequestDecorator
    include ::SpreeAvataxOfficial::HttpHelper

    def request(method, path, model, options = {})
      max_retries ||= ::SpreeAvataxOfficial::Config.max_retries

      super
    rescue *::SpreeAvataxOfficial::HttpHelper::CONNECTION_ERRORS => e
      retry unless (max_retries -= 1).zero?

      mock_error_response(e) # SpreeAvataxOfficial::HttpHelper method
    end
  end
end

# This is correct class to prepend because of: https://github.com/avadev/AvaTax-REST-V2-Ruby-SDK/blob/eb7c20b8e925a3d682f6414207e298e519e0a549/lib/avatax/api.rb#L25
::AvaTax::API.prepend ::Avatax::RequestDecorator
