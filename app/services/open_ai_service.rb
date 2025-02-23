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
      Estou criando um relatório técnico profissional para empresas no ramo da metalurgia. Necessito de uma introdução formal com em torno de 500 palavras contextualizando sobre o serviço realizado na peça.
      Dê uma breve explicação sobre o que é a peça, suas características, um resumo breve do que foi feito nela. Lembre-se de usar uma linguagem técnica e formal, seguir as normas da gramática, criar parágrafos
      bem elaborados com no mínimo 3 períodos e evitar uso de caracteres especiais. Use como base estes dados da peça e das etapas do processo realizado nela para você criar a introdução. Lembre-se que é importante
      usar os dados abaixo, use o nome da empresa contratante, a tag, o nome da peça, se baseie bastante da descrição da peça também. Use todo a seu favor e não deixe de incluir pontos importantes. Não use títulos ou subtítulos.

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
      Estou criando um relatório técnico profissional para empresas no ramo da metalurgia. Já desenvolvi uma introdução de em torno 500 palavras contextualizando sobre o serviço realizado
      na peça. Porém, agora preciso da descrição mais aprofundada e elaborada do que foi realizado nas etapas do processo com em torno de 2000 palavras. Quero que você aborde com profundidade e explore os detalhes das etapas.
      Use toda a descrição e dados das etapas a seu favor. Lembre-se, construa um texto formal e técnico, utilizando a linguagem formal e seguindo as normas da gramática. Crie parágrafos bem elaborados
      com no mínimo 3 períodos e evite uso de caracteres especiais. Não utilize títulos e subtítulos. Use como base estes dados da peça e das etapas do processo realizado.

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

  # def generate_report(report_data)
  #   prompt = """
  #     Por favor, gere um relatório técnico altamente detalhado sobre a peça fornecida, que pertence à empresa contratante. Este relatório deve ser elaborado com rigor técnico, apropriado para engenheiros, técnicos e especialistas na área, e com um nível de profundidade adequado para um documento de aproximadamente 15 mil palavras. O relatório deve conter as seguintes seções, cada uma bem detalhada e com uma linguagem técnica, precisa e clara:

  #     1. **Introdução:**
  #       - Contextualize a peça #{report_data[:nome_peca]} no processo industrial, fornecendo uma visão geral do seu papel e importância dentro do processo produtivo. Explique a necessidade de sua utilização no setor da empresa contratante, a função específica que ela desempenha e os desafios técnicos envolvidos.

  #     2. **Especificações Técnicas:**
  #       - Forneça as especificações detalhadas da peça, como material, dimensões, tolerâncias, processos de fabricação envolvidos, entre outros dados técnicos relevantes.
  #       - Detalhe as normas e padrões industriais que devem ser seguidos na produção e utilização dessa peça, mencionando as certificações, normas de qualidade e testes de conformidade que garantem sua integridade e desempenho.

  #     3. **Fluxo de Processo:**
  #       - Descreva o fluxo de trabalho completo que a peça segue, detalhando cada etapa de seu processo de fabricação e manutenção, desde a chegada ao ambiente de produção até sua finalização.
  #       - Detalhe os procedimentos específicos adotados em cada etapa, incluindo equipamentos e técnicas utilizadas, e os critérios de controle de qualidade e segurança envolvidos.

  #     4. **Análise das Etapas:**
  #       Para cada etapa do processo fornecida, use as informações detalhadas de cada etapa para gerar uma análise aprofundada:
  #       - **Etapa de Soldagem:**
  #         Descreva o tipo de solda, os parâmetros usados (temperatura, tipo de eletrodo, etc.), como foi controlada a solda para evitar falhas e garantir a resistência da união, e qualquer avaliação de controle de qualidade aplicada, como inspeções visuais ou testes de tração.
  #       - **Etapa de Teste de Pressão:**
  #         Explique o procedimento de teste, a metodologia de medição da pressão, os dispositivos utilizados e os critérios de aceitação ou rejeição de acordo com as normas do setor.
  #       - **Etapa de Limpeza:**
  #         Detalhe o processo de limpeza, incluindo os produtos utilizados, técnicas de remoção de sujeiras e resíduos, e a verificação de qualidade realizada para garantir que a peça tenha condições ideais para a próxima etapa do processo.

  #       ### Dados da Peça:
  #       - Nome: #{report_data[:nome_peca]}
  #       - TAG: #{report_data[:tag_peca]}
  #       - Empresa Contratante: #{report_data[:empresa_contratante]}
  #       - Etapas: #{report_data[:etapas].map { |step| "#{step[:nome]} - #{step[:data_inicio]} até #{step[:data_fim]}" }.join(", ")}

  #       ### Dados das Etapas:
  #       #{report_data[:etapas].map { |step| 
  #         """
  #         Etapa: #{step[:nome]}
  #         Data de Início: #{step[:data_inicio]}
  #         Data de Fim: #{step[:data_fim]}
  #         Descrição: #{step[:descricao]}
  #         """ 
  #       }.join("\n")}
        
  #     5. **Desafios Técnicos e Soluções Adotadas:**
  #       - Detalhe os principais desafios enfrentados durante a fabricação ou manutenção da peça, seja por questões de material, tolerâncias, falhas anteriores ou questões operacionais. Descreva as soluções técnicas aplicadas para contornar esses problemas, explicando o raciocínio técnico por trás de cada decisão tomada.

  #     6. **Considerações Finais e Recomendação Técnica:**
  #       - Forneça uma análise crítica sobre a peça, sua confiabilidade, durabilidade e adequação para o uso a que se destina. Dê recomendações sobre melhorias ou ajustes técnicos que poderiam ser feitos para otimizar sua performance no contexto industrial.
  #       - Aconselhe sobre o acompanhamento pós-manutenção e os planos de monitoramento a longo prazo para garantir a continuidade do desempenho ideal da peça.

  #     Lembre-se de usar uma linguagem técnica e precisa, apropriada para um público especializado, e de dividir as seções de maneira lógica, fluída e clara. O relatório deve ser conciso, mas extremamente detalhado, com o uso de terminologia adequada para engenheiros e técnicos da área.
  #     """

  #   body = {
  #     model: "gpt-3.5-turbo",
  #     messages: [
  #       { role: "user", content: prompt }
  #     ]
  #   }.to_json

  #   response = self.class.post("/chat/completions", @options.merge(body: body))
  #   response.parsed_response
  # end
end