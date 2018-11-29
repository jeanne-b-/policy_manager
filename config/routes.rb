PolicyManager::Engine.routes.draw do
  root 'terms#index'

  resources :terms

  resources :portability_requests do
    get :admin, on: :collection

    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    post :api_create, on: :collection
  end

  resources :anonymize_requests do
    get :admin, on: :collection

    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    post :api_create, on: :collection
  end
end
