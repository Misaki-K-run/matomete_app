Rails.application.routes.draw do
  # トップページ
  root "static_pages#top"

  # ログイン・新規登録・ログアウト・パスワードリセット
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # マイページ
  get "mypage", to: "posts#mypage"
  get "edit" => "users#edit"
  patch "update" => "users#update"

  # 投稿
  resources :posts, only: %i[index new create show edit update destroy]

  # Health check ルート（アップタイムモニタリング用）
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
