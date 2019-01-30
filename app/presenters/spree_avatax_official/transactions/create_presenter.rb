module SpreeAvataxOfficial
  module Transactions
    class CreatePresenter
      def initialize(order:, ship_from_address:, transaction_type:)
        @order = order
        @ship_from_address = ship_from_address
        @transaction_type = transaction_type
      end

      # Based on: https://developer.avalara.com/api-reference/avatax/rest/v2/models/CreateTransactionModel/
      def to_json
        {
          type: transaction_type,
          companyCode: SpreeAvataxOfficial::Config.company_code,
          date: formatted_date(order.updated_at),
          customerCode: order.email,
          addresses: addresses_payload,
          lines: line_items_payload(order.line_items),
          commit: order.complete?
        }
      end

      private

      attr_reader :order, :ship_from_address, :transaction_type

      def formatted_date(date)
        date.strftime('%Y-%m-%d')
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
