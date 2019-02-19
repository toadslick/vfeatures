Rails.application.routes.draw do

  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
    },
    controllers: {
      sessions: 'sessions',
    }

  resources :silos    , only: [:index, :show, :create, :update, :destroy]
  resources :features , only: [:index, :show, :create, :update, :destroy]
  resources :releases , only: [:index, :show, :create, :update, :destroy]
  resources :flags    , only: [:show, :update]
  resources :changes  , only: [:index]
  resources :users    , only: [:index]
end
