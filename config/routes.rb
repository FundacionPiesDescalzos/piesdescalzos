Rails.application.routes.draw do
  resources :activities
  resources :programs
  resources :nutritions do 
    get :export
    collection do 
      post :import 
    end
  end
  resources :homes
  resources :attendances
  resources :scores do
    get :export
    collection do
      post :import 
    end
  end
  resources :schools
  resources :establishments do 
    collection { post :import }
  end
  resources :health_cares
  resources :students do 
    get :export
    collection { post :import }
  end
  resources :guardians
  resources :visitors
  devise_for :users
  resources :users
  root :to => 'public#index'
	get '/home', :to => 'homes#banner'
	get '/reports', :to => 'reports#index'
	
end
