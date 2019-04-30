module Spree
  module RefundDecorator
    def self.prepended(base)
      base.after_create :refund_in_avatax

      base.delegate :order,                    to: :payment
      base.delegate :inventory_units, :number, to: :order, prefix: true
    end

    private

    def refund_in_avatax
      return unless SpreeAvataxOfficial::Config.enabled

      SpreeAvataxOfficial::Transactions::RefundService.call(refundable: self)
    end
  end
end

::Spree::Refund.prepend(::Spree::RefundDecorator) if 'Spree::Refund'.safe_constantize
