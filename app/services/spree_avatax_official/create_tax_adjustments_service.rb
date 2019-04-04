module SpreeAvataxOfficial
  class CreateTaxAdjustmentsService < SpreeAvataxOfficial::Base
    include SpreeAvataxOfficial::TaxAdjustmentLabelHelper

    def call(order:) # rubocop:disable Metrics/AbcSize
      return failure(I18n.t('spree_avatax_official.create_tax_adjustments.order_canceled')) if order.canceled?

      order.reload.all_adjustments.tax.destroy_all

      return failure(I18n.t('spree_avatax_official.create_tax_adjustments.tax_calculation_unnecessary')) unless order.avatax_tax_calculation_required?

      transaction_cache_key = SpreeAvataxOfficial::GenerateTransactionCacheKeyService.call(order: order).value
      avatax_response       = Rails.cache.fetch(transaction_cache_key, expires_in: 5.minutes) do
        send_transaction_to_avatax(order)
      end

      return failure(I18n.t('spree_avatax_official.create_tax_adjustments.tax_calculation_failed')) if avatax_failed_response?(avatax_response)

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

      item_suffix = avatax_item['lineNumber'].slice(0..2)
      item_id     = avatax_item['lineNumber'].slice(3..-1)
      item        = find_item(order, item_id, item_suffix)

      # Spree allows to setup shipping methods without tax category and
      # in that case it doesn't make sense to collect any tax,
      # especially because of validation that requires presence of tax category
      return if item.tax_category.nil?

      tax_rate = find_or_create_tax_rate(item, avatax_item)

      store_pre_tax_amount(item, tax_rate, tax_amount)

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

    def find_or_create_tax_rate(item, avatax_item)
      ::Spree::TaxRate.find_or_create_by!(
        name:               'AvaTax dummy tax rate',
        amount:             sum_rates_from_details(avatax_item),
        zone:               item.tax_zone,
        tax_category:       item.tax_category,
        show_rate_in_label: false,
        included_in_price:  item.included_in_price
      ) do |tax_rate|
        tax_rate.calculator = SpreeAvataxOfficial::Calculator::AvataxTransactionCalculator.new
      end
    end

    def create_tax_adjustment(item, source, amount)
      item.adjustments.create!(
        source:   source,
        amount:   amount,
        included: item.included_in_price,
        label:    tax_adjustment_label(item, source.amount),
        order:    item.order
      )
    end

    def store_pre_tax_amount(item, tax_rate, tax_amount)
      pre_tax_amount = case item.class.name.demodulize
                       when 'LineItem' then item.discounted_amount
                       when 'Shipment' then item.discounted_cost
                       end

      pre_tax_amount -= tax_amount if tax_rate.included_in_price?

      item.update_column(:pre_tax_amount, pre_tax_amount)
    end

    def sum_rates_from_details(avatax_item)
      avatax_item['details'].sum { |detail_entry| detail_entry['rate'] }
    end
  end
end
