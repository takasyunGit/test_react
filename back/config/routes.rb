Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks
  resources :sessions, only: :index

  namespace :api do
    namespace :v1 do
      resources :tests, only: %i[index]
      mount_devise_token_auth_for 'User', at: 'user', controllers: {
        registrations: 'api/v1/user/registrations'
      }
      namespace :user do
        resources :sessions, only: %i[index]
        resources :user_offers
      end
      mount_devise_token_auth_for 'Admin', at: 'admin', controllers: {
        registrations: 'api/v1/admin/registrations'
      }
      namespace :admin do
        resources :sessions, only: %i[index]
      end

      mount_devise_token_auth_for 'VendorUser', at: 'vendor_user', controllers: {
        registrations: 'api/v1/vendor_user/registrations'
      }
      namespace :vendor_user do
        resources :sessions, only: %i[index]
        resources :user_offers
        resources :vendor_offers
      end
    end
  end
end
