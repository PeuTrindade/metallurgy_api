require_dependency 'open_ai_service'

class ReportsController < ApplicationController
  def create
    part_id = params[:id]
    token = request.headers['Authorization']&.split(' ')&.last

    headers = {
      "Authorization" => "Bearer #{token}"
    }

    part_response = nil
    steps_response = nil
    threads = []

    threads << Thread.new do
      part_response = HTTParty.get("#{ENV['API_BASE_URL']}/part/#{part_id}", headers: headers, timeout: 10)
    end

    threads << Thread.new do
      steps_response = HTTParty.get("#{ENV['API_BASE_URL']}/steps/part/#{part_id}", headers: headers, timeout: 10)
    end

    threads.each(&:join)

    part = part_response.success? ? part_response.parsed_response : nil
    steps = steps_response.success? ? steps_response.parsed_response["steps"] : []

    report_data = {
      nome_peca: part["name"],
      tag_peca: part["tag"],
      empresa_contratante: part["empresa_contratante"],
      etapas: steps.map do |step|
        {
          nome: step["name"],
          data_inicio: step["startDate"],
          data_fim: step["finishDate"],
          descricao: step["description"] || "Descrição não informada."
        }
      end
    }

    open_ai_service = OpenAIService.new(ENV['OPENAI_API_KEY'])
    report_intro = open_ai_service.generate_intro(report_data)
    report_specifications = open_ai_service.generate_specifications(report_data)

    render json: { intro: report_intro, specifications: report_specifications }
  rescue StandardError => e
    render json: { error: "Erro interno: #{e.message}" }, status: :internal_server_error
  end
end
