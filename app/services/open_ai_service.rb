require 'httparty'

class OpenAIService
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(api_key)
    @api_key = api_key

    @options = {
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      }
    }
  end

  def generate_report(sales_data)
    prompt = "Gere um relatório detalhado sobre as vendas do último trimestre. Aqui estão os dados: #{sales_data}"

    body = {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "user", content: prompt }
      ]
    }.to_json

    response = self.class.post("/chat/completions", @options.merge(body: body))

    response.parsed_response
  end
end
