module SpreeAvataxOfficial
  class ItemPresenter
    def initialize(item:, custom_quantity: nil, custom_amount: nil)
      @item            = item
      @custom_quantity = custom_quantity
      @custom_amount   = custom_amount
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/LineItemModel/
    def to_json
      case item.class.name.demodulize
      when 'LineItem'
        shared_payload.merge(line_item_payload)
      else
        shared_payload
      end
    end

    delegate :inventory_units, to: :item

    private

    attr_reader :item, :custom_quantity, :custom_amount

    def shared_payload
      {
        number:     item.avatax_number,
        quantity:   item_quantity,
        amount:     item_amount,
        taxCode:    item.avatax_tax_code,
        discounted: discounted?,
        addresses:  line_item_addresses_payload
      }
    end

    def line_item_payload
      {
        description: item.description,
        sku:         item.variant.sku
      }
    end

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

    def with_addresses?
      item.class.name.demodulize == 'LineItem' && inventory_units.any?
    end

    # TODO: Handle the case where line item belongs to multiple stock locations - it may involve line items splitting
    def stock_location_address
      stock_location = inventory_units.first.shipment.stock_location

      {
        line1:      stock_location.address1,
        line2:      stock_location.address2,
        city:       stock_location.city,
        region:     stock_location.state.try(:abbr),
        country:    stock_location.country.try(:iso),
        postalCode: stock_location.zipcode
      }
    end

    def ship_from_payload
      SpreeAvataxOfficial::AddressPresenter.new(address: stock_location_address, address_type: 'ShipFrom').to_json
    end

    def ship_to_payload
      SpreeAvataxOfficial::AddressPresenter.new(address: item.order.tax_address, address_type: 'ShipTo').to_json
    end

    def line_item_addresses_payload
      with_addresses? ? ship_from_payload.merge(ship_to_payload) : {}
    end
  end
end
