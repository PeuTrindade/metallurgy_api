class ReportsController < ApplicationController
  before_action :authorize_request

  def create
    sales_data = {
      sales: [
        { month: "Janeiro", total: 15000, top_product: "Produto A" },
        { month: "Fevereiro", total: 18000, top_product: "Produto B" },
        { month: "Março", total: 22000, top_product: "Produto C" }
      ]
    }

    open_ai_service = OpenAIService.new(ENV['OPENAI_API_KEY'])

    report = open_ai_service.generate_report(sales_data)

    render json: { report: report }
  end
end
