module SpreeAvataxOfficial
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_many :avatax_transactions, class_name: 'SpreeAvataxOfficial::Transaction'

        base.has_one :avatax_sales_order_transaction, -> { where(transaction_type: 'SalesOrder') },
                class_name: 'SpreeAvataxOfficial::Transaction'
        base.has_one :avatax_sales_invoice_transaction, -> { where(transaction_type: 'SalesInvoice') },
                class_name: 'SpreeAvataxOfficial::Transaction'
      end
    end
  end
end

Spree::Order.prepend ::SpreeAvataxOfficial::Spree::OrderDecorator
