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
    resources :posting_applications, only: [:index, :show], module: "admin"
  end

  resources :roles, only: [:index, :show, :edit, :update]
  resources :users, only: [:index, :edit, :update]

  root "pages#dashboard"

  get "up" => "rails/health#show", as: :rails_health_check

  get "apply", to: "public/posting_applications#index", as: :apply_index
  get "apply/:slug/complete", to: "public/posting_applications#complete", as: :apply_complete
  get "apply/:slug(/:section_position)", to: "public/posting_applications#show", as: :apply, defaults: { section_position: 1 }
  patch "apply/:slug(/:section_position)", to: "public/posting_applications#update", defaults: { section_position: 1 }
end
