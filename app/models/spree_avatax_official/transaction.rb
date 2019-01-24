module SpreeAvataxOfficial
  class Transaction < ActiveRecord::Base
    AVAILABLE_TRANSACTION_TYPES = %w[SalesOrder SalesInvoice RefundInvoice].freeze

    belongs_to :order, class_name: 'Spree::Order'

    with_options presence: true do
      validates :code, uniqueness: true
      validates :order
      validates :transaction_type
    end

    validates :transaction_type, inclusion: { in: AVAILABLE_TRANSACTION_TYPES }

    scope :sales_orders,    -> { with_kind('SalesOrder') }
    scope :sales_invoices,  -> { with_kind('SalesInvoice') }
    scope :refund_invoices, -> { with_kind('RefundInvoice') }
    scope :with_kind,       ->(*s) { where(transaction_type: s) }
  end
end
