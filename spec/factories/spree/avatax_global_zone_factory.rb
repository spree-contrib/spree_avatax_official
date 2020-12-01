FactoryBot.define do
  factory :avatax_global_zone, class: Spree::Zone do
    name        { 'GlobalZone' }
    description { 'Description' }
    default_tax { true }

    after(:create) do |zone|
      create(:country) if Spree::Country.count.zero?

      Spree::Country.all.each do |country|
        # Spree < 3.1 is missing zone_member factory
        Spree::ZoneMember.create!(zone: zone, zoneable: country)
      end
    end
  end
end
