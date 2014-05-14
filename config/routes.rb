Rails.application.routes.draw do

  root 'pages#index'

  get '/about-cambase' => 'pages#about_cambase'
  get '/about-evercam' => 'pages#about_evercam'
  get '/privacy-policy' => 'pages#privacy'
  get '/cookie-policy' => 'pages#cookie'
  get '/contact-us' => 'pages#contact'
  get '/api-docs' => 'pages#api_docs'

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :cameras, :only => [:index] do
    collection do
      match 'search' => 'cameras#search', via: [:get, :post], as: :search
    end
  end

  resources :manufacturers, :only => [:index, :update, :create]

  resources :manufacturers, :path => '' do
    resources :cameras, :path => '', :except => [:index]
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :cameras
      resources :manufacturers
    end
  end


end
