Rails.application.routes.draw do
  resources :homes
  resources :attendances
  resources :scores do 
    collection { post :import }
  end
  resources :schools
  resources :establishments do 
    collection { post :import }
  end
  resources :health_cares
  resources :students do 
    collection { post :import }
  end
  resources :guardians
  resources :visitors
  devise_for :users
  resources :users
  root :to => 'public#index'
end
