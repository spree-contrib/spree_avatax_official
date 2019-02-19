require 'spree/testing_support/factories'

# According to documentation it's not possible to modify traits, what forces definition of new
# trait that covers differences between Spree versions. Link:
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#modifying-factories
FACTORY_BOT_CLASS.modify do
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
