module SpreeAvataxOfficial
  module Transactions
    class RefundService < SpreeAvataxOfficial::Base
      def call(refundable:)
        if full_refund?(refundable)
          create_full_refund(refundable)
        else
          create_partial_refund(refundable)
        end
      end

      private

      def full_refund?(refundable)
        refundable.order_inventory_units == inventory_units(refundable)
      end

      def refundable_class(refundable)
        @refundable_class ||= refundable.class.name.demodulize
      end

      def inventory_units(refundable)
        @inventory_units ||= case refundable_class(refundable)
                             when 'ReturnAuthorization'
                               refundable.inventory_units
                             when 'Refund'
                               refundable.reimbursement.return_items.map(&:inventory_unit)
                             end
      end

      def create_partial_refund(refundable)
        SpreeAvataxOfficial::Transactions::PartialRefundService.call(
          refundable_params(refundable).merge(
            refund_items: refund_items(refundable)
          )
        )
      end

      def refund_items(refundable)
        inventory_units(refundable).group_by(&:line_item).reduce({}) do |ids, (line_item, units)|
          ids.merge!(line_item => [units.count, -1 * line_item_amount(refundable, units)])
        end
      end

      def refundable_params(refundable)
        {
          order:            refundable.order,
          transaction_code: refund_transaction_code(refundable.order_number, refundable.id)
        }
      end

      def line_item_amount(refundable, units)
        case refundable_class(refundable)
        when 'ReturnAuthorization'
          units.flat_map(&:line_item).sum(&:pre_tax_amount)
        when 'Refund'
          units.flat_map(&:return_items).sum(&:pre_tax_amount)
        end
      end

      def create_full_refund(refundable)
        SpreeAvataxOfficial::Transactions::FullRefundService.call(
          refundable_params(refundable)
        )
      end
    end
  end
end
