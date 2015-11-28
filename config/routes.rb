Rails.application.routes.draw do
  root to: redirect("/session/new")

  resources :users, only: [:create, :new, :index, :show, :edit, :update]
  resource :session, only: [:create, :new, :destroy]

  # match '/login' => 'sessions#new', as: 'login'
  # match '/logout' => 'sessions#destroy', as: 'logout'
end
