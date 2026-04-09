Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "dashboard", to: "dashboard#index"

  resources :groups do
    resources :group_memberships, only: %i[create destroy]
    resources :invitations, only: %i[create]
  end

  get "invitations/:token", to: "invitations#show", as: :invitation
  get "invitations/:token/share", to: "invitations#share", as: :share_invitation
  post "group_memberships/accept", to: "group_memberships#accept", as: :accept_group_memberships

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
