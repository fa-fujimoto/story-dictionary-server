Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  resource :account, only: [:show]
  resources :users, only: [:index, :show], param: :name do
    resources :projects, only: [:index, :show], param: :term_id do
      resources :words, only: [:index, :show], param: :term_id
    end
  end
end
