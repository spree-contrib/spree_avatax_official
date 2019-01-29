module SpreeAvataxOfficial
  class LineItemPresenter
    def initialize(line_item:)
      @line_item = line_item
    end

    # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/LineItemModel/
    def to_json
      {
        number: line_item.variant.sku,
        quantity: line_item.quantity,
        amount: line_item.amount
      }
    end

    private

    attr_reader :line_item
  end
end
