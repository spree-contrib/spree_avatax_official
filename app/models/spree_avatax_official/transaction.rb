module SpreeAvataxOfficial
  class Transaction < ActiveRecord::Base
    AVAILABLE_TRANSACTION_TYPES = %w[SalesOrder SalesInvoice RefundOrder RefundInvoice].freeze

    belongs_to :order, class_name: 'Spree::Order'

    with_options presence: true do
      validates :code, uniqueness: true
      validates :order
      validates :transaction_type
    end

    validates :transaction_type, inclusion: { in: AVAILABLE_TRANSACTION_TYPES }
  end
end
