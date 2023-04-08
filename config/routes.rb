Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations'}
  devise_scope :user do
    get 'users', to: "users/registrations#index"
  end
  resources :jogging_times, only: %i[create destroy edit update index]
  root "jogging_times#index"
end
