Rails.application.routes.draw do
  resources :homes
  resources :attendances
  resources :scores
  resources :schools
  resources :establishments do 
    collection { post :import }
  end
  resources :health_cares
  resources :students
  resources :guardians
  resources :visitors
  devise_for :users
  resources :users
  root :to => 'public#index'
end
