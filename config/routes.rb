Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '' do
    namespace :me do
      jsonapi_resources :tasks do
        get :export, on: :collection
      end
    end

    jsonapi_resources :tasks do
      get :export, on: :collection
    end

    resources :users do
      get :me, on: :collection
      patch :password, on: :member
    end

    devise_scope :user do
      resources :sessions, :only => [:create] do
        collection do
          delete :destroy
        end
      end
    end
  end

  devise_for :users,
    controllers: {
      registrations: 'users'
    },
    skip: [:sessions, :passwords, :confirmations, :registrations]

  namespace :development do
    get 'tasks_export'
  end
end
