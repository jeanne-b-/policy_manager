PolicyManager::Engine.routes.draw do
  resource :terms, only: :index  
  root 'terms#index'
end
