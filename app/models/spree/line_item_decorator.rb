module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      AVATAX_CODE = 'LI'.freeze

      def avatax_number
        "#{id}-#{AVATAX_CODE}"
      end
    end
  end
end

Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
