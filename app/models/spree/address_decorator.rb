module SpreeAvataxOfficial
  module Spree
    module AddressDecorator
      OBSERVABLE_FIELDS = %w[address1 address2 city zipcode state_id country_id].freeze

      def self.prepended(base)
        base.around_save :recalculate_avatax_taxes
      end

      private

      def recalculate_avatax_taxes
        return yield unless SpreeAvataxOfficial::Config.enabled

        observed_fields_changed = OBSERVABLE_FIELDS & changed

        yield # around_save requires yield to perform save operation

        return unless observed_fields_changed.any? && persisted?

        address_sym = ::Spree::Config.tax_using_ship_address ? :ship_address : :bill_address
        order       = ::Spree::Order.incomplete.find_by(address_sym => self)

        return if order.blank?

        order.recalculate_avatax_taxes
      end
    end
  end
end

# Temporarily commented out for a project with multiple namespaces
# Spree::Address.prepend ::SpreeAvataxOfficial::Spree::AddressDecorator
