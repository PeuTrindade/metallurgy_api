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

  def generate_intro(report_data)
    prompt = """ 
      Estou criando um relatório técnico profissional para empresas no ramo da metalurgia. Necessito de uma introdução formal com um mínimo de 500 palavras contextualizando sobre o serviço realizado na peça. 
      Dê uma explicação detalhada sobre o que é a peça, suas características e um resumo abrangente do que foi feito nela. Lembre-se de usar uma linguagem técnica e formal, seguir as normas da gramática, criar parágrafos
      bem elaborados com no mínimo 3 períodos e evitar uso de caracteres especiais. Use como base estes dados da peça e das etapas do processo realizado nela para criar a introdução. Lembre-se que é importante
      utilizar todos os dados abaixo, incluindo o nome da empresa contratante, a tag, o nome da peça e a descrição detalhada da peça. Desenvolva um texto longo, descritivo e técnico.
      
      Dados da Peça:
        - Nome: #{report_data[:nome_peca]}
        - TAG: #{report_data[:tag_peca]}
        - Descrição da peça: #{report_data[:descricao_peca]}
        - Empresa Contratante: #{report_data[:empresa_contratante]}
        - Etapas: #{report_data[:etapas].map { |step| "#{step[:nome]} - #{step[:data_inicio]} até #{step[:data_fim]}" }.join(", ")}

      Dados das Etapas:
        #{report_data[:etapas].map { |step| 
         """
        Etapa: #{step[:nome]}
        Data de Início: #{step[:data_inicio]}
        Data de Fim: #{step[:data_fim]}
        Descrição: #{step[:descricao]}
         """ 
        }.join("\n")}
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

  def generate_specifications(report_data)
    prompt = """
      Estou criando um relatório técnico profissional para empresas no ramo da metalurgia. Já desenvolvi uma introdução com no mínimo 500 palavras contextualizando sobre o serviço realizado
      na peça. Agora preciso da descrição detalhada e aprofundada do que foi realizado nas etapas do processo, com no mínimo 4000 palavras. Quero que você aborde com profundidade e explore os detalhes técnicos das etapas.
      Use toda a descrição e dados das etapas a seu favor. Lembre-se, construa um texto formal e técnico, utilizando linguagem precisa e seguindo as normas da gramática. Crie parágrafos bem elaborados
      com no mínimo 3 períodos e evite uso de caracteres especiais. Não utilize títulos e subtítulos. Desenvolva o texto de forma longa e descritiva.
      
      Dados da Peça:
        - Nome: #{report_data[:nome_peca]}
        - TAG: #{report_data[:tag_peca]}
        - Descrição da peça: #{report_data[:descricao_peca]}
        - Empresa Contratante: #{report_data[:empresa_contratante]}
        - Etapas: #{report_data[:etapas].map { |step| "#{step[:nome]} - #{step[:data_inicio]} até #{step[:data_fim]}" }.join(", ")}

      Dados das Etapas:
        #{report_data[:etapas].map { |step| 
        """
        Etapa: #{step[:nome]}
        Data de Início: #{step[:data_inicio]}
        Data de Fim: #{step[:data_fim]}
        Descrição: #{step[:descricao]}
        """ 
        }.join("\n")}
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

  def generate_inspection(report_data)
    prompt = """
      Estou criando um relatório técnico profissional para empresas no ramo da metalurgia. Já desenvolvi uma introdução com no mínimo 500 palavras contextualizando o serviço realizado na peça e descrições detalhadas
      de cada etapa realizada com no mínimo 4000 palavras. Agora, quero que você gere uma seção de inspeção final, na qual discorra sobre como se deu a verificação e análise de tudo o que foi feito na peça. O texto deve ter no mínimo 500 palavras.
      Use como base o texto que irei lhe passar, que contém informações sobre a inspeção realizada pela empresa. Lembre-se, construa um texto formal e técnico, utilizando uma linguagem precisa e seguindo as normas da gramática. Crie parágrafos bem elaborados,
      com no mínimo 3 períodos e evite uso de caracteres especiais. Não utilize títulos e subtítulos. Desenvolva o texto de forma longa, estruturada e detalhada.
      
      Inspeção final: #{report_data[:inspecao_final]}
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
