Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'

  resources :users
  get '/signin', to: 'users#signin'
  get '/signup', to: 'users#signup'
  # Error routing
  get '/403', to: 'errors#permission_denied'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'
  # Alternative error routes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
