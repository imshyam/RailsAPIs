Rails.application.routes.draw do
  #get 'v1/index'

  match ':controller(/:action(/:id))', :via => :get

  root 'v1#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
