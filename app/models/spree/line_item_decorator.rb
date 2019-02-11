module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      AVATAX_CODE = 'LI'.freeze
    end
  end
end

Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
