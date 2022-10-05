Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :authentication, only: [] do
        collection do
          post :login
          post :sign_up
          post :forgot_password
          post :verify_token
          post :reset_password
        end
      end

      resources :social_login, only: [] do
        collection do
          post :social_login
        end
      end
    end
  end
end
