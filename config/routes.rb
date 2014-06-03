Rails.application.routes.draw do

  root 'pages#index'

  get '/about-cambase' => 'pages#about_cambase'
  get '/about-evercam' => 'pages#about_evercam'
  get '/terms-of-service' => 'pages#terms'
  get '/contact-us' => 'pages#contact'
  get '/api-docs' => 'pages#api_docs'
  get '/settings' => 'pages#settings'

  post '/admin/history', to: 'cameras#history', as: :cameras_history
  post "/versions", to: "versions#change", :as => "change_version"

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, defaults: {format: 'json'} do
    get '/' => '/api#index'
    namespace :v1 do
      get '/' => '/api#index'
      resources :cameras do 
        collection do
          get 'search' => 'cameras#search', as: :search
        end
      end
      resources :manufacturers
    end
  end

  resources :cameras, :only => [:index, :update] do
    collection do
      match 'search' => 'cameras#search', via: [:get, :post], as: :search
    end
  end

  resources :manufacturers, :only => [:index, :update, :create]

  resources :manufacturers, :except => [:new], :path => '' do
    resources :cameras, :path => '', :except => [:index, :new]
  end

end
