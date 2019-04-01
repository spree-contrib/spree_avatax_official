module SpreeAvataxOfficial
  module Spree
    module OrderUpdaterDecorator
      # Previous implementation of this method in Spree < 3.0.0 did NOT recalculate
      # additional_tax_total for item that didn't have any adjustments. In case of
      # adjustment removal, item would keep old additional_tax_total.
      def recalculate_adjustments
        return super if ::Gem::Version.new(::Spree.version) >= ::Gem::Version.new('3.0.0')

        order.taxable_items.each { |item| ::Spree::ItemAdjustments.new(item).update }
      end
    end
  end
end

::Spree::OrderUpdater.prepend ::SpreeAvataxOfficial::Spree::OrderUpdaterDecorator
