Rails.application.routes.draw do
  devise_for :users
  resources :jogging_times, only: %i[create destroy edit update index]
  root "jogging_times#index"
end
