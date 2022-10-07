Rails.application.routes.draw do
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "admin/dashboard#index"

  namespace :admin do
    resources :dashboard do
      collection do
      end
    end
    resources :guidelines, only: [:index, :update, :edit] do
      collection do
        get :get_page
      end
    end
    resources :users, only: [:index, :show]
    resources :bestie, only: [:index, :show]
    resources :sub_admins, only: [:index, :new, :create]
  end

  namespace :api do
    namespace :v1 do
      resources :authentication, only: [] do
        collection do
          post :login
          post :sign_up
          post :forgot_password
          post :verify_token
          post :reset_password
          put :update_social_login
          get :get_interests
        end
      end

      resources :social_login, only: [] do
        collection do
          post :social_login
        end
      end
      get 'static_page', to: 'static_page#static_page'
    end
  end
end
