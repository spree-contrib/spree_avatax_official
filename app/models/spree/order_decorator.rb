module SpreeAvataxOfficial
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_many :avatax_transactions, class_name: 'SpreeAvataxOfficial::Transaction'

        base.has_one :avatax_sales_order_transaction, -> { where(transaction_type: 'SalesOrder') },
                     class_name: 'SpreeAvataxOfficial::Transaction',
                     inverse_of: :order

        base.has_one :avatax_sales_invoice_transaction, -> { where(transaction_type: 'SalesInvoice') },
                     class_name: 'SpreeAvataxOfficial::Transaction',
                     inverse_of: :order

        base.state_machine.after_transition to: :canceled, do: :void_in_avatax
      end

      private

      def void_in_avatax
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::Transactions::VoidService.call(order: self)
      end
    end
  end
end

Spree::Order.prepend ::SpreeAvataxOfficial::Spree::OrderDecorator
