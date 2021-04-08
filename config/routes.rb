Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/most_items', to: 'merchants#most_items'
      namespace :merchants do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
      end
      namespace :items do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
      end
      namespace :revenue do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index]
        resources :unshipped, only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: :item_merchant
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index, :show], controller: :merchant_items
      end

    end
  end
end
