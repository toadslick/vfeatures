Rails.application.routes.draw do
  resources :silos    , only: [:index, :show, :create, :update, :destroy]
  resources :features , only: [:index, :show, :create, :update, :destroy]
  resources :releases , only: [:index, :show, :create, :update, :destroy]
  resources :flags    , only: [:show, :update]
end
