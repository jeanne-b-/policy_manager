PolicyManager::Engine.routes.draw do
  resources :terms
  resources :portability_requests do
    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    get :admin, on: :collection
  end
  root 'terms#index'
end
