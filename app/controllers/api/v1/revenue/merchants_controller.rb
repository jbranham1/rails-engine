class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].blank? || params[:quantity].to_i < 1
      render json: ErrorSerializer.new, status: :bad_request
    else
      render json: MerchantsRevenueSerializer.new(Merchant.merchants_with_most_revenue(quantity))
    end
  end
end
