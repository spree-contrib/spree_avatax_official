module AvaTax
  module RequestDecorator
    include ::SpreeAvataxOfficial::HttpHelper

    def request(method, path, model, options = {})
      super
    rescue *::SpreeAvataxOfficial::HttpHelper::CONNECTION_ERRORS => e
      mock_error_response(e) # SpreeAvataxOfficial::HttpHelper method
    end
  end
end

# This is correct class to prepend because of: https://github.com/avadev/AvaTax-REST-V2-Ruby-SDK/blob/eb7c20b8e925a3d682f6414207e298e519e0a549/lib/avatax/api.rb#L25
::AvaTax::API.prepend ::AvaTax::RequestDecorator
