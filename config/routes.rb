Rails.application.routes.draw do
  # トップページ
  root "static_pages#top"

  # ログイン・新規登録・ログアウト・パスワードリセット
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # マイページ
  get "mypage", to: "posts#mypage"
  get "edit" => "users#edit"
  patch "update" => "users#update"

  # 投稿
  resources :posts, only: %i[index new create show edit update destroy] do
    collection do
      get :bookmarks
    end
  end

  # AI自動生成
  resources :ai_generates, only: [ :new, :create, :show ] do
    collection do
      get :favorites
    end
  end

  # bookmark
  resources :bookmarks, only: %i[create destroy]

  # favorite
  resources :favorites, only: [ :create, :destroy ]

  # 利用規約・プライバシーポリシー
  get "privacy_policy" => "static_pages#privacy_policy", as: :privacy_policy
  get "terms_of_service" => "static_pages#terms_of_service", as: :terms_of_service

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
