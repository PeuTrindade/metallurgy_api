Rails.application.routes.draw do
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'

  # Rotas protegidas
  put '/profile', to: 'users#update'
  post '/step', to: 'steps#create'
  put '/step/:id', to: 'steps#update'
  delete '/step/:id', to: 'steps#destroy'
  get '/steps', to: 'steps#index'
end
