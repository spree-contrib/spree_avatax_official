FACTORY_BOT_CLASS.define do
  factory :spree_avatax_official_transaction, class: SpreeAvataxOfficial::Transaction do
    transaction_type { 'SalesOrder' }
    sequence(:code, &:to_s)
    association :order, factory: :spree_order
  end
end
