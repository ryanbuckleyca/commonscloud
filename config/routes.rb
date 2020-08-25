Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :users, only: [ :update, :show ]

  resources :posts, only: [ :index, :new, :create, :show ] do
    resources :connections, only: [ :create, :update ]
  end
end
