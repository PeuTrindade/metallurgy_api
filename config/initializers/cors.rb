# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Ou um conjunto de origens, ex: 'http://example.com'

    resource '*', 
      headers: :any, 
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'] # Opcional: Expor cabeçalhos personalizados, como 'Authorization'
  end
end
