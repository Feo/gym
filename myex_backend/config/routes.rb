MyexBackend::Application.routes.draw do

  root :to => 'sessions#new'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy', :via => :delete
  resources :sessions
  mount API::Root => '/'
  resources :administrators do
    member do
      get 'message_index'
      post 'message_create_all'
    end

    collection do
      get 'notices'
      get 'notice_show'
      post 'message_update_all'
      get 'notice_special_view'
      post 'message_create_special'

    end
  end
  
end
