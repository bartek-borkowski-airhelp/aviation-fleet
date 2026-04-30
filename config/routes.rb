Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  resources :manufacturers, only: %i[index show create update destroy] do
    resources :families, controller: :aircraft_families, only: %i[index create]
  end

  resources :families, controller: :aircraft_families, only: %i[show update destroy]

  # Nested variants under families
  get "families/:family_id/variants", to: "aircraft_variants#nested_index"
  post "families/:family_id/variants", to: "aircraft_variants#create"

  resources :variants, controller: :aircraft_variants, only: %i[index show update destroy] do
    member do
      post :discontinue
      get :operators
    end
  end

  resources :airlines, only: %i[index show create update destroy] do
    member do
      get :fleet, to: "airlines#fleet"
    end
    resources :fleet, controller: :fleet_entries, only: %i[create update destroy] do
      member do
        post "phase-out", to: "fleet_entries#phase_out"
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
