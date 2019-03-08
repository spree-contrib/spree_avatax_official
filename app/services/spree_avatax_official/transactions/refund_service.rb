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
        order(refundable).inventory_units == inventory_units(refundable)
      end

      def order(refundable)
        @order ||= case refundable_class(refundable)
                   when 'ReturnAuthorization'
                     refundable.order
                   when 'Refund'
                     refundable.reimbursement.order
                   end
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
          order:        order(refundable),
          refund_items: refund_items(refundable)
        )
      end

      def refund_items(refundable)
        inventory_units(refundable).group_by(&:line_item).reduce({}) do |ids, (line_item, units)|
          ids.merge!(line_item => [units.count, line_item_amount(refundable, units)])
        end
      end

      def line_item_amount(refundable, units)
        return unless refundable_class(refundable) == 'Refund'

        units.flat_map(&:return_items).sum(&:pre_tax_amount)
      end

      def create_full_refund(refundable)
        SpreeAvataxOfficial::Transactions::FullRefundService.call(
          order: order(refundable)
        )
      end
    end
  end
end
