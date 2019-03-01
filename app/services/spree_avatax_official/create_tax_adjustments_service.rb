module SpreeAvataxOfficial
  class CreateTaxAdjustmentsService < SpreeAvataxOfficial::Base
    def call(order:)
      return failure(I18n.t('spree_avatax_official.create_tax_adjustments.order_canceled')) if order.canceled?

      order.reload.all_adjustments.tax.destroy_all

      avatax_response = send_transaction_to_avatax(order)

      return failure(false) if avatax_failed_response?(avatax_response)

      process_avatax_items(order, avatax_response.value['lines'])

      success(true)
    end

    private

    def send_transaction_to_avatax(order)
      if order.avatax_sales_invoice_transaction.present?
        SpreeAvataxOfficial::Transactions::AdjustService.call(
          order:                  order,
          adjustment_reason:      SpreeAvataxOfficial::Transaction::DEFAULT_ADJUSTMENT_REASON,
          adjustment_description: I18n.t('spree_avatax_official.create_tax_adjustments.adjustment_description')
        )
      else
        SpreeAvataxOfficial::Transactions::CreateService.call(order: order)
      end
    end

    def avatax_failed_response?(avatax_response)
      avatax_response.failure? || avatax_response.value['totalTax'].zero?
    end

    def process_avatax_items(order, avatax_items)
      avatax_items.each { |avatax_item| process_avatax_item(order, avatax_item) }
    end

    def process_avatax_item(order, avatax_item)
      tax_amount = avatax_item['taxCalculated']

      return if tax_amount.zero?

      item_suffix = avatax_item['lineNumber'].slice!(0..2)
      item_id     = avatax_item['lineNumber']
      item        = find_item(order, item_id, item_suffix)
      tax_rate    = find_or_create_tax_rate(item)

      create_tax_adjustment(item, tax_rate, tax_amount)
    end

    def find_item(order, uuid, suffix)
      case suffix
      when 'LI-'
        order.line_items.find_by(avatax_uuid: uuid)
      when 'FR-'
        order.shipments.find_by(avatax_uuid: uuid)
      end
    end

    def find_or_create_tax_rate(item)
      ::Spree::TaxRate.find_or_create_by!(
        name:               'AvaTax dummy tax rate',
        amount:             0.0,
        zone:               ::Spree::Zone.default_tax,
        tax_category:       item.tax_category,
        show_rate_in_label: false
      ) do |tax_rate|
        tax_rate.calculator = SpreeAvataxOfficial::Calculator::AvataxTransactionCalculator.new
      end
    end

    def create_tax_adjustment(item, source, amount)
      ::Spree::Adjustment.create!(
        source:     source,
        adjustable: item,
        amount:     amount,
        included:   false,
        label:      'AvaTax Tax adjustment',
        order:      item.order
      )
    end
  end
end
