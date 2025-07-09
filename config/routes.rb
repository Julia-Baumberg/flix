# frozen_string_literal: true

Rails.application.routes.draw do
  resources :genres
  resources :users
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites, only: %i[create destroy]
  end

  get 'movies/filter/:filter' => 'movies#index', as: :filtered_movies
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resource :session, only: %i[new create destroy]
end
