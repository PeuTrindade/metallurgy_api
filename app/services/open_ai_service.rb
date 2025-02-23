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
      Por favor, forneça uma contextualização detalhada e técnica sobre a peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) no processo industrial. Este texto deve ter aproximadamente 500 palavras e deve abordar os seguintes pontos:

      1. **Visão Geral do Papel da Peça no Processo Produtivo:**
        Explique a importância da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) dentro do sistema de produção da empresa contratante. Discuta como a peça se insere no fluxo de trabalho e sua relação com outras partes do processo de produção. Considere seu papel no ambiente industrial, mencionando sua aplicabilidade e os sistemas ou maquinários com os quais ela interage diretamente.

      2. **Necessidade de Utilização no Setor da Empresa Contratante:**
        Apresente a razão pela qual a peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) é essencial para a empresa contratante. Qual a função que ela exerce especificamente e por que ela é crucial para o sucesso da operação? Descreva como a peça contribui para a eficiência do processo, segurança operacional e/ou qualidade do produto final. Se possível, relacione a peça a uma aplicação prática ou a um desafio específico enfrentado pela empresa no setor industrial.

      3. **Função Específica que a Peça Desempenha:**
        Detalhe as funções técnicas da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) no contexto do processo de fabricação. Como ela ajuda a atingir os objetivos do processo produtivo, e quais são suas propriedades e características que a tornam ideal para tal aplicação? A peça desempenha algum papel vital na garantia de desempenho, segurança, ou qualidade?

      4. **Desafios Técnicos Envolvidos:**
        Explore os desafios técnicos associados à produção ou à utilização da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}). Quais são os requisitos específicos de fabricação que precisam ser atendidos para garantir a funcionalidade da peça? Existem dificuldades quanto ao material utilizado, tolerâncias exigidas, testes de qualidade ou processos de montagem? Além disso, considere o impacto que essas dificuldades podem ter sobre o desempenho ou sobre o processo industrial, e como elas são superadas ou mitigadas.

      O texto deve ser escrito de forma técnica, mas clara, e deve destacar a importância da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) dentro do contexto específico da empresa contratante, abordando as complexidades envolvidas em sua fabricação e aplicação.
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
        Por favor, forneça uma contextualização detalhada e técnica sobre a peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) no processo industrial, com um enfoque nas especificações técnicas da peça. Este texto deve ter aproximadamente 1000 palavras e abordar os seguintes pontos:

        1. **Especificações Técnicas da Peça:**
          - Explique as especificações detalhadas da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}), incluindo:
            - **Material:** Descreva o material utilizado na fabricação da peça, suas propriedades específicas e as razões pelas quais esse material foi escolhido. Detalhe as características do material, como resistência à corrosão, dureza, condutividade térmica ou elétrica, e como essas propriedades são essenciais para a performance da peça no ambiente industrial. Considerando o tipo de aplicação e os requisitos do setor da empresa contratante, discuta as vantagens e limitações do material.
            - **Dimensões e Tolerâncias:** Forneça informações detalhadas sobre as dimensões da peça, incluindo as tolerâncias permitidas para garantir que a peça se encaixe corretamente no processo produtivo. Explique os métodos e ferramentas usados para medir e controlar as dimensões, e como as tolerâncias são mantidas dentro dos limites especificados. Discuta a importância de manter essas dimensões dentro dos padrões para garantir a funcionalidade e a segurança do produto final.
            - **Processos de Fabricação e Tratamentos:** Detalhe os processos de fabricação envolvidos na produção da peça, como fundição, usinagem, estampagem, entre outros. Explique como cada um desses processos é executado, os parâmetros críticos de controle e a importância de cada um para garantir que a peça atenda aos requisitos do processo produtivo. Discuta também os tratamentos ou acabamentos realizados na peça, como tratamentos térmicos, galvanização ou revestimentos especiais, e como esses processos impactam a performance da peça e sua longevidade.
            - **Normas e Certificações:** Mencione as normas e padrões industriais que devem ser seguidos durante a fabricação e utilização da peça. Detalhe as certificações de qualidade que foram obtidas, como as normas ISO ou outras certificações relevantes, e como elas garantem que a peça atende a todos os requisitos de qualidade e segurança exigidos. Explique como essas certificações influenciam o controle de qualidade durante a produção e contribuem para garantir a integridade da peça.
            - **Testes de Conformidade:** Detalhe os testes de conformidade realizados para validar a peça, como testes de resistência, durabilidade, funcionalidade e outros testes específicos de desempenho. Explique como esses testes são conduzidos e quais critérios de aceitação são usados para determinar se a peça cumpre os requisitos especificados. Discuta a importância desses testes para garantir que a peça seja segura e confiável em seu ambiente de aplicação.

        2. **Impacto das Especificações no Processo Produtivo:**
          - Explique como as especificações técnicas da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) impactam diretamente o processo produtivo da empresa contratante. Discuta como a escolha do material, as dimensões precisas e os processos de fabricação afetam a eficiência e a qualidade da produção. Considere os desafios que podem surgir durante a fabricação, como variações de material, tolerâncias de fabricação, ou falhas de processo, e como essas questões são gerenciadas para garantir que a peça atenda aos requisitos industriais.

        3. **Função da Peça no Contexto do Processo Industrial:**
          - Discuta o papel técnico da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) no contexto do processo industrial. Explique como as especificações detalhadas da peça garantem que ela desempenhe a função desejada dentro do processo produtivo. Considere como a peça interage com outros componentes ou sistemas da linha de produção, e como suas propriedades, como resistência e precisão dimensional, contribuem para a eficiência e a segurança do processo.

        4. **Desafios Técnicos Envolvidos na Produção:**
          - Aborde os desafios técnicos que surgem durante a produção ou utilização da peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}). Quais são os principais obstáculos na escolha do material, fabricação e testes da peça? Discuta como os processos de fabricação e controle de qualidade são ajustados para garantir a precisão dimensional, a resistência e a durabilidade da peça. Se houver desafios específicos quanto a tolerâncias extremas, necessidade de alta precisão ou testes rigorosos, explique como a equipe de engenharia ou produção lida com esses aspectos para garantir que a peça atenda aos padrões exigidos.

        O texto deve ser técnico e claro como um relatório técnico profissional, não use símbolos, apenas parágrafos, com ênfase nas especificações detalhadas e na importância de cada aspecto para garantir que a peça #{report_data[:nome_peca]} (TAG: #{report_data[:tag_peca]}) atenda aos requisitos do processo produtivo da empresa contratante e cumpra as normas de qualidade estabelecidas.

        ### Dados da Peça:
        - Nome: #{report_data[:nome_peca]}
        - TAG: #{report_data[:tag_peca]}
        - Empresa Contratante: #{report_data[:empresa_contratante]}

        ### Etapas:
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