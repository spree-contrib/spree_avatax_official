module SpreeAvataxOfficial
  module Calculator
    class AvataxTransactionCalculator < ::Spree::Calculator::DefaultTax
      def self.description
        'AvaTax transaction calculator'
      end

      def compute_order(_order)
        raise 'Tax adjustments should be calculated on line item or shipment level'
      end

      # Following lines require this recalculation:
      # https://github.com/spree/spree/blob/master/core/app/models/spree/adjustment.rb#L104
      # https://github.com/spree/spree/blob/master/core/app/models/spree/line_item.rb#L159
      def compute_line_item(line_item)
        line_item.adjustments.tax.sum(:amount)
      end

      def compute_shipment(shipment)
        shipment.adjustments.tax.sum(:amount)
      end

      def compute_shipping_rate(_shipping_rate)
        0
      end
    end
  end
end
