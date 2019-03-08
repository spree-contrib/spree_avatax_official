module SpreeAvataxOfficial
  class ItemPresenter
    def initialize(item:, custom_quantity: nil, custom_amount: nil)
      @item            = item
      @custom_quantity = custom_quantity
      @custom_amount   = custom_amount
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/LineItemModel/
    def to_json
      {
        number:     item.avatax_number,
        quantity:   item_quantity,
        amount:     item_amount,
        taxCode:    item.avatax_tax_code,
        discounted: discounted?
      }
    end

    private

    attr_reader :item, :custom_quantity, :custom_amount

    def item_quantity
      custom_quantity || item.try(:quantity) || 1
    end

    def item_amount
      custom_amount || item.discounted_amount
    end

    def discounted?
      case item.class.name.demodulize
      when 'LineItem'
        item.order.line_items_discounted_in_avatax?
      when 'Shipment'
        # we do not want to apply order level discounts to shipments
        false
      end
    end
  end
end
