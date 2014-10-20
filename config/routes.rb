Rails.application.routes.draw do

  root 'pages#index'

  get '/about-cambase' => 'pages#about_cambase'
  get '/about-evercam' => 'pages#about_evercam'
  get '/terms-of-service' => 'pages#terms'
  get '/contact-us' => 'pages#contact'
  get '/api-docs' => 'pages#api_docs'
  get '/settings' => 'pages#settings'

  post '/admin/history', to: 'models#history', as: :cameras_history
  post "/versions", to: "versions#change", :as => "change_version"

  get '/users/auth', to: 'users#auth'

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, defaults: {format: 'json'} do
    get '/' => '/api#index'
    namespace :v1 do
      get '/' => '/api#index'
      resources :models do
        collection do
          get 'search' => 'models#search', as: :search
        end
      end
      resources :recorders do
        collection do
          get 'search' => 'recorders#search', as: :search
        end
      end
      resources :vendors
      resources :changes
    end
  end

  resources :models, :only => [:index, :update] do
    collection do
      match 'search' => 'models#search', via: [:get, :post], as: :search
    end
  end

  resources :recorders, :only => [:index, :update] do
    collection do
      match 'search' => 'recorders#search', via: [:get, :post], as: :search
    end
  end

  resources :vendors, :only => [:index, :update, :create]
  resources :models, :path => ':vendor_slug/models/'
  resources :recorders, :path => ':vendor_slug/recorders/'

end
