Rails.application.routes.draw do
  devise_for :users, path: 'auth'
  resources :users, only: %i[new create edit update index destroy]
  resources :jogging_times, only: %i[new create destroy edit update index]
  root "static_pages#home"
end
