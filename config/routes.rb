Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :users, only: [ :update, :show, :index ] do
    resources :chatrooms, only: :show
    resources :messages, only: :create
  end

  resources :posts, only: [ :index, :new, :create, :show ] do
    resources :connections, only: [ :create, :update ]
  end
end
