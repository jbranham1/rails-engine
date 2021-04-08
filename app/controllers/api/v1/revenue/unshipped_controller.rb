class Api::V1::Revenue::UnshippedController < ApplicationController
  def index
    if quantity.blank? || quantity < 1
      render json: ErrorSerializer.new, status: :bad_request
    else
      render json: UnshippedOrderSerializer.new(Invoice.unshipped_revenue(quantity))
    end
  end

  private

  def quantity
    params.fetch(:quantity, 10).to_i
  end
end
