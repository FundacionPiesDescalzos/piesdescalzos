Rails.application.routes.draw do
  resources :students
  resources :guardians
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
