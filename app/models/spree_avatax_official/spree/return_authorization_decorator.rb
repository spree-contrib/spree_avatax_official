module SpreeAvataxOfficial
  module Spree
    module ReturnAuthorizationDecorator
      def self.prepended(base)
        base.delegate :inventory_units, :number, to: :order, prefix: true
      end
    end
  end
end

::Spree::ReturnAuthorization.prepend(::SpreeAvataxOfficial::Spree::ReturnAuthorizationDecorator) unless 'Spree::Refund'.safe_constantize
