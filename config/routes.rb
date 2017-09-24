Rails.application.routes.draw do
  #get 'v1/index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :current
    end
  end

  resources :current
  root to: 'current#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
