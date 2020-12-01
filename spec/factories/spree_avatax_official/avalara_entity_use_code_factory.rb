FactoryBot.define do
  factory :avalara_entity_use_code, class: SpreeAvataxOfficial::EntityUseCode do
    code { 'A' }
    name { 'Federal government' }
    description { 'Federal government' }
  end
end
