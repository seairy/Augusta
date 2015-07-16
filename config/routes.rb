# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  mount API => '/api'
  root 'frontend/home#index'
  get 'app', to: 'frontend/home#get'
  namespace :cms do
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    get 'search', to: 'searches#show', as: :search
    resources :venues do
      resources :courses
    end
    resources :courses do
      resources :holes
    end
    resources :holes do
      resources :tee_boxes
      member do
        put :update_par
      end
    end
    resources :tee_boxes do
      member do
        put :update_distance_from_hole
      end
    end
    resources :versions do
      member do
        put :publish
        put :cancel
      end
    end
    resources :administrators
    resource :profile do
      get 'edit_password'
      put 'update_password'
    end
    get 'signin', to: 'sessions#new', as: :signin
    post 'signin', to: 'sessions#create'
    get 'signout', to: 'sessions#destroy', as: :signout
    get 'errors/403', to: 'errors#error_403', as: :error_403
    resources :errors
    get '*not_found', to: 'errors#error_404'
  end
  namespace :wechat do
    root 'base#verify', via: [:get, :post]
  end
  namespace :caddie do
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :players
    resources :caddies
    resources :scorecards
    get 'signin_with_open_id', to: 'sessions#create_with_open_id', as: :signin_with_open_id
    get 'oauth2', to: 'sessions#oauth2', as: :oauth2
    get 'simulate', to: 'sessions#simulate', as: :simulate
  end
end