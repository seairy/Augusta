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
  namespace :caddie do
    root 'base#verify', via: [:get, :post]
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :verification_codes do
      collection do
        post :sign_up
      end
    end
    resources :players
    resources :caddies
    resources :scorecards
    post 'sign_in', to: 'sessions#create', as: :sign_in
    get 'sign_up', to: 'caddies#sign_up_form', as: :sign_up_form
    post 'sign_up', to: 'caddies#sign_up', as: :sign_up
    get 'simulate_sign_in', to: 'sessions#simulate_sign_in', as: :simulate_sign_in
  end
end