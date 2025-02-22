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

  def generate_report(report_data)
    prompt = """
      Por favor, gere um relatório detalhado e formal, com uma linguagem técnica e profissional, seguindo os padrões de um relatório acadêmico, sobre a peça **#{report_data[:nome_peca]}** (TAG: **#{report_data[:tag_peca]}**),
      que pertence à empresa **#{report_data[:empresa_contratante]}**. O relatório deve ser bem estruturado, com parágrafos claros e bem definidos, e deve cobrir as seguintes informações de maneira profunda:

      - Descrição da peça, suas características e aplicação.
      - O histórico da peça dentro do contexto da produção.
      - Detalhamento das etapas de produção, conforme as seguintes informações:
        #{report_data[:etapas].map.with_index { |step, index| 
          "#{index + 1}. **Etapa:** #{step[:nome]}\n   - **Data de início:** #{step[:data_inicio]}\n   - **Data de término:** #{step[:data_fim]}\n   - **Descrição:** #{step[:descricao]}" 
        }.join("\n\n")}
      - Qualquer outro dado relevante relacionado à peça e seu processo de fabricação.

      Utilize um estilo acadêmico, com parágrafos coesos e uma redação fluente, adequada para um público técnico e especializado.
    """

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