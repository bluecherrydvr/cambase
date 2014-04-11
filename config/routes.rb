Rails.application.routes.draw do

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  resources :cameras

  resources :manufacturers

  root 'pages#index'

  get '/about-cambase' => 'pages#about_cambase'
  get '/about-evercam' => 'pages#about_evercam'
  get '/privacy-policy' => 'pages#privacy'
  get '/cookie-policy' => 'pages#cookie'
  get '/contact-us' => 'pages#contact'

end
