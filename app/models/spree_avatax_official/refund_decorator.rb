module SpreeAvataxOfficial
  module RefundDecorator
    def self.prepended(base)
      base.state_machine.after_transition to: :received, do: :refund_in_avatax
    end

    private

    def refund_in_avatax
      SpreeAvataxOfficial::Transactions::RefundService.call(refund_object: self)
    end
  end
end
