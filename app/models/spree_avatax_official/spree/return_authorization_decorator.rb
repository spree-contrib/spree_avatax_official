module SpreeAvataxOfficial
  module Spree
    module ReturnAuthorizationDecorator
      def self.prepended(base)
        base.delegate :inventory_units, to: :order, prefix: true
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# ::Spree::ReturnAuthorization.prepend(::SpreeAvataxOfficial::Spree::ReturnAuthorizationDecorator)
