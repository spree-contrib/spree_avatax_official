namespace :spree_avatax_official do
  desc 'Migrate from SpreeAvataxCertified and create initial data.'
  task load_seeds: :environment do
    SpreeAvataxOfficial::Seeder.new.seed!
  end
end
