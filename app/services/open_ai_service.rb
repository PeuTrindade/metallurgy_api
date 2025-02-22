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
      Gere um relatório extremamente detalhado e profissional em **Markdown** sobre a peça **#{report_data[:nome_peca]}** (TAG: **#{report_data[:tag_peca]}**),
      que pertence à empresa **#{report_data[:empresa_contratante]}**. O relatório deve conter todos os detalhes técnicos e históricos da peça e das etapas de sua fabricação. O conteúdo deve ser bem estruturado, com títulos, subtítulos e descrições precisas e completas. O relatório deve cobrir os seguintes pontos:

      ## 1. Informações Gerais da Peça
      - **Nome da Peça**: #{report_data[:nome_peca]}
      - **TAG da Peça**: #{report_data[:tag_peca]}
      - **Empresa Contratante**: #{report_data[:empresa_contratante]}
      - **Descrição Geral**: Forneça uma descrição detalhada da peça, incluindo seu objetivo e importância no contexto de produção da empresa.
      - **Características Técnicas**: Detalhe as especificações técnicas da peça, como material, dimensões, peso, tolerâncias e quaisquer outras informações relevantes.
      - **Histórico de Produção**: Relate o histórico de produção da peça, se aplicável, incluindo a data de fabricação, qualquer modificação ou reprocessamento relevante e contexto histórico.

      ## 2. Detalhamento das Etapas

      Para cada etapa, forneça uma descrição completa da atividade realizada, com explicações detalhadas sobre a técnica utilizada, equipamentos envolvidos, desafios encontrados e a importância de cada fase no contexto da produção da peça.

      #{report_data[:etapas].each_with_index.map do |step, index|
        """
        ### Etapa #{index + 1}: #{step[:nome]}
        - **Data de Início**: #{step[:data_inicio]}
        - **Data de Término**: #{step[:data_fim]}
        - **Descrição Detalhada**: #{step[:descricao]}
        - **Objetivo da Etapa**: Explique o propósito dessa etapa no processo de fabricação da peça.
        - **Tecnologias/Equipamentos Utilizados**: Liste as tecnologias ou equipamentos utilizados nessa etapa.
        - **Desafios e Soluções**: Detalhe qualquer desafio enfrentado durante a execução da etapa e como foi superado.
        - **Qualidade e Precisão**: Comente sobre os aspectos de qualidade e precisão da etapa, e como isso impacta a qualidade final da peça.
        - **Impacto da Etapa no Processo Global**: Relate como essa etapa contribui para o sucesso do processo de fabricação completo.

        """
      end.join("\n")}

      ## 3. Conclusões e Recomendações

      - **Sumário Final**: Resuma as principais conclusões sobre a peça e as etapas de fabricação.
      - **Recomendações Técnicas**: Caso necessário, forneça recomendações para melhorar o processo de fabricação, qualidade ou eficiência da produção.
      - **Potenciais Melhorias**: Baseado nas etapas descritas, sugira possíveis melhorias no processo de fabricação.
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