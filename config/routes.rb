Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  },
  # 不要なアクションをスキップ
  skip: [ :registrations, :password ]

  # ログアウトのルーティングをscopeで指定
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  root "static_pages#top"

  post "callback" => "linebot#callback"

  resources :items
  resources :notifications, only: %i[edit update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  # 全てのビューファイルでの404エラーに対して対応
  match "*path", to: "application#render_404", via: :all
end
