Rails.application.routes.draw do
  resources :attendances
  resources :scores
  resources :schools
  resources :establishments do 
    collection { post :import }
  end
  resources :health_cares
  resources :students
  resources :guardians
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
