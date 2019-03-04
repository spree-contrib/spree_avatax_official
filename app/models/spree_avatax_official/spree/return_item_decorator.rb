module SpreeAvataxOfficial
  module Spree
    module ReturnItemDecorator
      def self.prepended(base)
        base.state_machine.after_transition to: :received, do: :refund_in_avatax
      end

      private

      def refund_in_avatax
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::Transactions::RefundService.call(refundable: self)
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# ::Spree::ReturnItem.prepend(::SpreeAvataxOfficial::Spree::ReturnItemDecorator) if 'Spree::ReturnItem'.safe_constantize
