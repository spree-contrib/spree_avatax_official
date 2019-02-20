module SpreeAvataxOfficial
  class ItemPresenter
    def initialize(item:, quantity: nil)
      @item     = item
      @quantity = quantity
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/LineItemModel/
    def to_json
      {
        number:     item.avatax_number,
        quantity:   item_quantity,
        amount:     item.discounted_amount,
        taxCode:    tax_code,
        discounted: discounted?
      }
    end

    private

    attr_reader :item, :quantity

    def item_quantity
      quantity || item.try(:quantity) || 1
    end

    def tax_code
      item.tax_category&.tax_code.presence || default_tax_code
    end

    def default_tax_code
      ::Spree::TaxCategory::DEFAULT_TAX_CODES[item.class.to_s]
    end

    def discounted?
      case item
      when ::Spree::LineItem
        item.order.adjustments.promotion.eligible.any?
      when ::Spree::Shipment
        # we do not want to apply order level discounts to shipments
        false
      end
    end
  end
end
