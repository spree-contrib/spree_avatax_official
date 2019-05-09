module SpreeAvataxOfficial
  module Spree
    module ReturnAuthorizationDecorator
      def self.prepended(base)
        base.delegate :inventory_units, :number, to: :order, prefix: true

        base.state_machine do
          after_transition to: :received, do: :refund_in_avatax
        end
      end

      private

      def refund_in_avatax
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::Transactions::RefundService.call(refundable: self)
      end
    end
  end
end

::Spree::ReturnAuthorization.prepend(::SpreeAvataxOfficial::Spree::ReturnAuthorizationDecorator) unless 'Spree::Refund'.safe_constantize
