module SpreeAvataxOfficial
  module Spree
    module InventoryUnitDecorator
      def self.prepended(base)
        base.has_many :return_items, inverse_of: :inventory_unit, class_name: 'Spree::ReturnItem'
      end
    end
  end
end

::Spree::InventoryUnit.prepend(::SpreeAvataxOfficial::Spree::InventoryUnitDecorator)
