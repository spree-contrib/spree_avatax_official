module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      AVATAX_CODE = 'FR'.freeze
    end
  end
end

Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
