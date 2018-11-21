PolicyManager::Engine.routes.draw do
  resources :terms
  resources :portability_requests do
    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    get :admin, on: :collection
    get :api_create, on: :collection
  end
  root 'terms#index'
end
