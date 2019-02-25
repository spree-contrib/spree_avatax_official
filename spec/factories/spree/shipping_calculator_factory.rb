require 'spree/testing_support/factories'

# Turns out Spree 2.2 doesn't have this calculator defined
unless FACTORY_BOT_CLASS.factories.registered?(:shipping_calculator)
  FACTORY_BOT_CLASS.define do
    factory :shipping_calculator, class: Spree::Calculator::Shipping::FlatRate do
      after(:create) { |c| c.set_preference(:amount, 10.0) }
    end
  end
end
