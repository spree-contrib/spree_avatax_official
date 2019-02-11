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
        amount: line_item.amount,
        taxCode: tax_code
      }
    end

    private

    attr_reader :line_item

    def tax_code
      line_item.tax_category&.tax_code.presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['Spree::LineItem']
    end
  end
end
