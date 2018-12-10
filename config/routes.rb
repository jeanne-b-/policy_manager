PolicyManager::Engine.routes.draw do
  root 'terms#index'

  resources :terms do
    post :sign, on: :member
    post :publish, on: :member
    post :archive, on: :member
  end

  resources :portability_requests, only: [:index, :new, :create] do
    get :admin, on: :collection

    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    post :api_create, on: :collection
  end

  resources :anonymize_requests, only: [:index, :new, :create] do
    get :admin, on: :collection

    post :cancel, on: :member
    post :approve, on: :member
    post :deny, on: :member
    post :api_create, on: :collection
  end
end
