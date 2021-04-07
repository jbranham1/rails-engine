class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_page_limit(page, per_page))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def most_items
    if params[:quantity].blank? || params[:quantity].to_i < 1
      render json: ErrorSerializer.new, status: :bad_request
    else
      render json: ItemsSoldSerializer.new(Merchant.merchants_with_most_items(quantity))
    end
  end

  private

  def quantity
    params.fetch(:quantity, 5).to_i
  end
end
