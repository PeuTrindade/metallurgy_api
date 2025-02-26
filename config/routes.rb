Rails.application.routes.draw do
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'
  post '/me', to: 'auth#validate_token'

  # Rotas protegidas
  
  # Usuário
  put '/profile', to: 'users#update'

  # Etapa
  post '/step', to: 'steps#create'
  put '/step/:id', to: 'steps#update'
  delete '/step/:id', to: 'steps#destroy'
  get '/steps', to: 'steps#index'
  get '/steps/flow/:flow_id', to: 'steps#by_flow'
  get '/step/:id', to: 'steps#show'
  get '/steps/part/:part_id', to: 'steps#by_part'

  # Etapa modelo
  post '/steps_flow', to: 'steps_flow#create'
  put '/steps_flow/:id', to: 'steps_flow#update'
  delete '/steps_flow/:id', to: 'steps_flow#destroy'
  get '/steps_flow', to: 'steps_flow#index'
  get '/steps_flow/flow/:flow_id', to: 'steps_flow#by_flow'
  get '/steps_flow/:id', to: 'steps_flow#show'

  # Peça
  post '/part', to: 'parts#create'
  get '/parts', to: 'parts#index'
  put '/part/:id', to: 'parts#update'
  delete '/part/:id', to: 'parts#destroy'
  get '/parts/flow/:flow_id', to: 'parts#by_flow'
  get '/part/:id', to: 'parts#show'

  # Fluxo
  post '/flow', to: 'flows#create'
  get '/flows', to: 'flows#index'
  put '/flow/:id', to: 'flows#update'
  delete '/flow/:id', to: 'flows#destroy'
  get '/flow/:id', to: 'flows#show'

  # Relatório
  post '/report/:id', to: 'reports#create'
end
