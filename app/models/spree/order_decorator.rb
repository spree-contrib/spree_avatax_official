module SpreeAvataxOfficial
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.register_update_hook :recalculate_avatax_taxes

        base.has_many :avatax_transactions, class_name: 'SpreeAvataxOfficial::Transaction'

        base.has_one :avatax_sales_invoice_transaction, -> { where(transaction_type: 'SalesInvoice') },
                     class_name: 'SpreeAvataxOfficial::Transaction',
                     inverse_of: :order

        base.state_machine.after_transition to: :canceled, do: :void_in_avatax
        base.state_machine.after_transition to: :complete, do: :commit_in_avatax
      end

      def taxable_items
        line_items.reload + shipments.reload
      end

      def avatax_sales_invoice_code
        avatax_sales_invoice_transaction.try(:code)
      end

      def avatax_tax_calculation_required?
        tax_address.present? && line_items.any?
      end

      def avatax_discount_amount
        adjustments.promotion.eligible.sum(:amount).abs
      end

      def avatax_ship_from_address
        SpreeAvataxOfficial::Config.ship_from_address
      end

      def line_items_discounted_in_avatax?
        adjustments.promotion.eligible.any?
      end

      def tax_address_symbol
        ::Spree::Config.tax_using_ship_address ? :ship_address : :bill_address
      end

      def create_tax_charge!
        return super unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::CreateTaxAdjustmentsService.call(order: self)
      end

      def recalculate_avatax_taxes
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::CreateTaxAdjustmentsService.call(order: self)
        update_totals
        persist_totals
      end

      private

      def commit_in_avatax
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::Transactions::CreateService.call(order: self)
      end

      def void_in_avatax
        return unless SpreeAvataxOfficial::Config.enabled

        SpreeAvataxOfficial::Transactions::VoidService.call(order: self)
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# Spree::Order.prepend ::SpreeAvataxOfficial::Spree::OrderDecorator
