require 'spree/testing_support/factories'

FACTORY_BOT_CLASS.modify do
  factory :line_item, class: Spree::LineItem do
    before(:create) do |line_item|
      uuid = 'a844605f-e114-4933-a0cf-7a434ac83cdf'

      line_item.avatax_uuid = uuid if Spree::LineItem.find_by(avatax_uuid: uuid).nil?
    end
  end
end
