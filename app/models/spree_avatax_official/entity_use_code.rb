module SpreeAvataxOfficial
  class EntityUseCode < ::Spree::Base
    with_options presence: true do
      validates :code, :name, uniqueness: true
    end
  end
end
