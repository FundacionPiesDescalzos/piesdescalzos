Rails.application.routes.draw do
  resources :attendances
  resources :scores
  resources :schools
  resources :establishments
  resources :health_cares
  resources :students
  resources :guardians
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
