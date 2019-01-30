module SpreeAvataxOfficial
  class Transaction < ActiveRecord::Base
    SALES_ORDER    = 'SalesOrder'.freeze
    SALES_INVOICE  = 'SalesInvoice'.freeze
    REFUND_INVOICE = 'RefundInvoice'.freeze

    AVAILABLE_TRANSACTION_TYPES = [
      SALES_ORDER,
      SALES_INVOICE,
      REFUND_INVOICE
    ].freeze

    belongs_to :order, class_name: 'Spree::Order'

    with_options presence: true do
      validates :code, uniqueness: true
      validates :order
      validates :transaction_type
    end

    validates :transaction_type, inclusion: { in: AVAILABLE_TRANSACTION_TYPES }

    scope :sales_orders,    -> { with_kind(SALES_ORDER) }
    scope :sales_invoices,  -> { with_kind(SALES_INVOICE) }
    scope :refund_invoices, -> { with_kind(REFUND_INVOICE) }
    scope :with_kind,       ->(*s) { where(transaction_type: s) }
  end
end
