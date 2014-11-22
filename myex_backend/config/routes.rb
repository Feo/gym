MyexBackend::Application.routes.draw do

  root :to => 'sessions#new'
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy', :via => :delete
  match '/login', :to => 'sessions#new'
  match ':member_id/share_score', to: 'shares#share_score'
  match ':member_id/share_record/:record_id', to: 'shares#share_record'
  resources :sessions do
    collection do
      get 'forget_password'
      post 'send_token'
      get 'reset'
      post 'reset_password'
    end
  end
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
      post 'notice_special_view'
      post 'message_create_special'
      get 'notice_all_member'
      post 'notice_all_member_create'
      post 'notice_special_member'
      post 'notice_special_member_create'
      get 'find_special_coach'
      post 'find_coaches'
      get 'find_special_member'

    end
  end
  
end
