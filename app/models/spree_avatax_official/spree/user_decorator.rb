module SpreeAvataxOfficial
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_one :spree_avatax_official_entity_use_code, class_name: 'SpreeAvataxOfficial::EntityUseCode'
      end
    end
  end
end

::Spree::User.prepend ::SpreeAvataxOfficial::Spree::UserDecorator
