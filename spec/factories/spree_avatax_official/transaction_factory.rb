FACTORY_BOT_CLASS.define do
  factory :spree_avatax_official_transaction, class: SpreeAvataxOfficial::Transaction do
    transaction_type { 'SalesInvoice' }
    code             { order.number }
    association :order, factory: :order

    trait :return_invoice do
      transaction_type { 'ReturnInvoice' }
      code             { "#{order.number}-1" }
    end
  end
end
