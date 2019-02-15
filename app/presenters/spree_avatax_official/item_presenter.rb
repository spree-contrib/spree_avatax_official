module SpreeAvataxOfficial
  class ItemPresenter
    def initialize(item:)
      @item = item
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

    attr_reader :item

    def item_quantity
      item.is_a?(::Spree::LineItem) ? item.quantity : 1
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
