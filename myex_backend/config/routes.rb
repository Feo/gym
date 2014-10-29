MyexBackend::Application.routes.draw do

  root :to => 'sessions#new'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy', :via => :delete
  resources :sessions
  mount API::Root => '/'
  resources :administrators
  
end
