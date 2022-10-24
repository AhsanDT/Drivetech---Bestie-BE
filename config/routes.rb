Rails.application.routes.draw do
  devise_for :admins,
             controllers: {
                 sessions: 'admins/sessions',
                 registrations: 'admins/registrations'
             }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "admins/dashboard#index"

  namespace :admins do
    resources :dashboard do
      collection do
      end
    end
    resources :guidelines, only: [:index, :update, :edit] do
      collection do
        get :get_page
      end
    end
    resources :users, only: [:index, :show] do
      collection do
        get 'export_to_csv', defaults: { format: :csv }
      end
    end
    resources :bestie, only: [:index, :show] do
      collection do
        get 'export_to_csv', defaults: { format: :csv }
      end
    end
    resources :sub_admins, only: [:index, :update] do
      collection do
        get 'export_to_csv', defaults: { format: :csv }
      end
    end
    resources :supports, only: [:index, :new, :create] do
      collection do
        get 'user_chat'
        get 'download'
        get 'update_ticket_status'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :authentication, only: [] do
        collection do
          post :login
          post :uniq_email_and_phone
          post :sign_up
          post :forgot_password
          post :verify_token
          post :reset_password
          put :update_social_login
          get :get_interests
          get :get_talents
        end
      end

      resources :social_login, only: [] do
        collection do
          post :social_login
        end
      end
      get 'static_page', to: 'static_page#static_page'

      resources :supports, only: [:index, :create] do
        post 'create_message'
        get 'get_messages'
      end

      resources :support_conversations, only: [:index, :create, :destroy] do
        collection do
          post 'create_message'
          get 'get_messages'
        end
      end
    end
  end
end
