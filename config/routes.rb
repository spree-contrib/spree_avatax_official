Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :avatax_settings, only: %i[edit update]
    resource :avatax_ping, only: :create

    resources :users do
      member do
        get :avalara_information
        put :avalara_information
      end
    end

    resources :avalara_entity_use_codes, except: :show
  end
end
