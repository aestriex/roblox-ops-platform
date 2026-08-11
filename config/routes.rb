Rails.application.routes.draw do
  get "pages/dashboard"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :job_postings do
    patch :update_status, on: :member
    resources :sections do
      patch :reorder, on: :collection
      get :new_button, on: :collection
      resources :questions do
        patch :reorder, on: :collection
      end
    end
  end

  resources :roles, only: [:index, :show, :edit, :update]
  resources :users, only: [:index, :edit, :update]

  root "pages#dashboard"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
