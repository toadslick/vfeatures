Rails.application.routes.draw do
  defaults format: :json do
    resources :silos    , only: [:index, :show, :create, :update, :destroy]
    resources :features , only: [:index, :show, :create, :update, :destroy]
    resources :releases , only: [:index, :show, :create, :update, :destroy]
  end
end
