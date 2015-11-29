Rails.application.routes.draw do
  root to: redirect("/session/new")

  resources :users, only: [:create, :index, :show, :edit, :update]
  resource :session, only: [:destroy]

  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post'login' => 'sessions#create'
end
