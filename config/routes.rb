PolicyManager::Engine.routes.draw do
  resources :terms
  resources :portability_requests
  root 'terms#index'
end
