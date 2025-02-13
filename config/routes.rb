Rails.application.routes.draw do
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'

  # Rotas protegidas
  
  # Usuário
  put '/profile', to: 'users#update'

  # Etapa
  post '/step', to: 'steps#create'
  put '/step/:id', to: 'steps#update'
  delete '/step/:id', to: 'steps#destroy'
  get '/steps', to: 'steps#index'
  get '/steps/flow/:flow_id', to: 'steps#by_flow'

  # Peça
  post '/part', to: 'parts#create'
  get '/parts', to: 'parts#index'
  put '/part/:id', to: 'parts#update'
  delete '/part/:id', to: 'parts#destroy'
  get '/parts/flow/:flow_id', to: 'parts#by_flow'

  # Fluxo
  post '/flow', to: 'flows#create'
  get '/flows', to: 'flows#index'
  put '/flow/:id', to: 'flows#update'
  delete '/flow/:id', to: 'flows#destroy'
end
