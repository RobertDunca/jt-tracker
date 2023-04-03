Rails.application.routes.draw do
  devise_for :users
  resources :jogging_times, only: %i[create destroy edit]
  root "jogging_times#home"
end
