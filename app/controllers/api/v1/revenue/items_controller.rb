class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if params[:quantity].nil? || params[:quantity].to_i > 0
      render json: ItemRevenueSerializer.new(Item.items_with_most_revenue(quantity))
    else
      render json: ErrorSerializer.new, status: :bad_request
    end
  end

  private

  def quantity
    params.fetch(:quantity, 10).to_i
  end
end
