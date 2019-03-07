module SpreeAvataxOfficial
  module Spree
    module RefundDecorator
      def self.prepended(base)
        base.after_create :refund_in_avatax
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
# ::Spree::Refund.prepend(::SpreeAvataxOfficial::Spree::RefundDecorator) if 'Spree::Refund'.safe_constantize
