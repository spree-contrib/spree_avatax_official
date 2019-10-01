Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :avatax_settings, only: %i[edit update]
  end
end
