Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => "/cable"

  devise_for :admins,
             controllers: {
                 sessions: 'admins/sessions',
                 registrations: 'admins/registrations',
                 passwords: 'admins/passwords'
             }
  devise_scope :admin do
    get 'reset_password_instruction', to: 'admins/passwords#custom_reset_password_action'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "admins/dashboard#index"

  mount StripeEvent::Engine, at: '/webhooks'

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
        get :export_to_csv, defaults: { format: :csv }
      end
    end
    resources :bestie, only: [:index, :show] do
      collection do
        get :export_to_csv, defaults: { format: :csv }
      end
    end
    resources :sub_admins, only: [:index, :update] do
      collection do
        get :export_to_csv, defaults: { format: :csv }
      end
    end
    resources :supports, only: [:index, :new, :create] do
      collection do
        get :user_chat
        get :download
        get :update_ticket_status
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :authentication, only: [] do
        collection do
          post :login
          post :uniq_email_and_phone
          post :uniq_phone_number
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
      get :static_page, to: 'static_page#static_page'

      resources :supports, only: [:index, :create] do
        post :create_message
        get :get_messages
      end

      resources :support_conversations, only: [:index, :create, :destroy] do
        collection do
          post :create_message
          post :get_messages
        end
      end

      resources :conversations, only: [:index, :create, :destroy] do
        collection do
          post :create_message
          post :get_messages
          put :change_read_status
          get :get_unread_messages
          post :update_user_status
        end
      end

      resources :cards

      put :update_media, to: 'media#update_media'

      resources :profile, only: [] do
        collection do
          put :update_profile
          post :switch_user
          post :update_user_interests
          post :update_user_talents
          put :update_social_media
          put :update_portfolio
        end
      end

      post :notification_mobile_token, to: "notifications#notification_mobile_token"

      resources :banks

      post :notification_mobile_token, to: 'notifications#notification_mobile_token'
      get :get_notifications, to: 'notifications#get_notifications'
      
      resources :users, only: [] do
        collection do
          post :suggested_besties
          get :besties_near_you
          get :home
          get :search
          get :recent_besties
          post :filter
          get :map_users
        end
      end
      
      resources :subscriptions, only: [:create, :destroy] do
        collection do
          get :get_packages
          get :current_user_subscription
        end
      end

      resources :user_profile, only: [] do
        collection do
          get :get_profile
          get :get_profile_image
          get :get_camera_detail
          get :get_portfolio
          post :get_user_profile
          post :search_by_name
        end
      end
      
      resources :schedules, only: [:create] do
        collection do
          post :besties_availablity
          post :bestie_schedule
        end
      end

      resources :posts, only: [:create, :update, :index, :destroy, :show] do
        collection do
          get :all_posts
          post :time_slots
        end
      end

      resources :applied_job_posts
      resources :saved_job_posts
      
      resources :block_users, only: [:create, :index, :destroy] do
        collection do
          post :report
        end
      end

      resources :stripe_connect, only: [] do
        collection do
          post :connect
          get :get_connect_account
          get :create_login_link
        end
      end

      resources :bookings, only: [:create, :update] do
        collection do
          post :send_reschedule
          post :reschedule
          get :current_user_bookings
          post :cancel_booking
          post :release_payment
          get :pending_bookings
          post :search_pending_bookings
          post :add_more_time
          post :finish_early
        end
      end

      resources :reviews, only: [:create, :index] do
        collection do
          get :pending_reviews
        end
      end

      resources :reviews

      resources :payments, only: [:create] do
        collection do
          post :transfer
          post :make_default_payment
          post :create_payment
        end
      end

      resources :pay_pal, only: [] do
        collection do
          post :pay_pal_confirm
          post :create_paypal_customer_account
          get :create_payment
          post :transfer_amount
          get :create_payout
          post :save_paypal_account_details
          post :update_default
          post :delete_paypal
        end
      end
    end
  end
end
