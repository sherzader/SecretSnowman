Rails.application.routes.draw do

  resources :users, only: [:create, :index, :show, :edit, :update]
  resource :session, only: [:destroy]

  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post'login' => 'sessions#create'
  root to: redirect("/signup")
end
