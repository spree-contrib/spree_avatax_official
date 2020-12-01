require 'spree/testing_support/factories'

# According to documentation it's not possible to modify traits, what forces definition of new
# trait that covers differences between Spree versions. Link:
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#modifying-factories
if FactoryBot.factories.registered?(:promotion)
FactoryBot.modify do
    factory :promotion, class: Spree::Promotion do
      trait :avatax_with_order_adjustment do
        transient do
          weighted_order_adjustment_amount { 10 }
        end

        after(:create) do |promotion, evaluator|
          calculator = Spree::Calculator::FlatRate.new(preferred_amount: evaluator.weighted_order_adjustment_amount)
          Spree::Promotion::Actions::CreateAdjustment.create!(calculator: calculator, promotion: promotion)
        end
      end
    end
  end
end

unless FactoryBot.factories.registered?(:free_shipping_promotion)
FactoryBot.define do
    factory :free_shipping_promotion, class: Spree::Promotion do
      name { 'Free Shipping Promotion' }

      after(:create) do |promotion|
        action           = Spree::Promotion::Actions::FreeShipping.new
        action.promotion = promotion
        action.save
      end
    end
  end
end
