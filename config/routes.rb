Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :users, only: [ :update, :show, :index ]

  resources :posts, only: [ :index, :new, :create, :show ] do
    resources :connections, only: [ :create, :update ]
  end

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
end
