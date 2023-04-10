Rails.application.routes.draw do
  # devise_for :users, controllers: { registrations: 'users/registrations'}
  devise_for :users, path: 'auth', controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: %i[new create edit update index destroy]
  resources :jogging_times, only: %i[new create destroy edit update index]
  root "application#home"
end
