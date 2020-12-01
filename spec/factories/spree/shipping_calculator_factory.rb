require 'spree/testing_support/factories'

# Turns out Spree 2.2 doesn't have this calculator defined
unless FactoryBot.factories.registered?(:shipping_calculator)
FactoryBot.define do
    factory :shipping_calculator, class: Spree::Calculator::Shipping::FlatRate do
      after(:create) { |c| c.set_preference(:amount, 10.0) }
    end
  end
end
