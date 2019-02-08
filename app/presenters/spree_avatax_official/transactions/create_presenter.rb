module SpreeAvataxOfficial
  module Transactions
    class CreatePresenter
      def initialize(order:, ship_from_address:, transaction_type:, transaction_code: nil)
        @order = order
        @ship_from_address = ship_from_address
        @transaction_type = transaction_type
        @transaction_code = transaction_code
      end

      # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/CreateTransactionModel/
      def to_json
        {
          type: transaction_type,
          code: transaction_code,
          companyCode: company_code,
          date: formatted_date(order_date),
          customerCode: order.email,
          addresses: addresses_payload,
          lines: line_items_payload(order.line_items),
          commit: order.complete?
        }
      end

      private

      attr_reader :order, :ship_from_address, :transaction_type, :transaction_code

      def company_code
        order.store&.avatax_company_code || SpreeAvataxOfficial::Config.company_code
      end

      def formatted_date(date)
        date.strftime('%Y-%m-%d')
      end

      def order_date
        order.completed_at || order.updated_at
      end

      def ship_from_payload
        SpreeAvataxOfficial::AddressPresenter.new(address: ship_from_address, address_type: 'ShipFrom').to_json
      end

      def ship_to_payload
        tax_address = ::Spree::Config[:tax_using_ship_address] ? order.ship_address : order.bill_address

        SpreeAvataxOfficial::AddressPresenter.new(address: tax_address, address_type: 'ShipTo').to_json
      end

      def addresses_payload
        ship_from_payload.merge(ship_to_payload)
      end

      def line_items_payload(line_items)
        line_items.map { |line_item| SpreeAvataxOfficial::LineItemPresenter.new(line_item: line_item).to_json }
      end
    end
  end
end
