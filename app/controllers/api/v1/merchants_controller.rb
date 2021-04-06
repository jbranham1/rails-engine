class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_page_limit(page, per_page))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def most_items
    render json: MerchantSerializer.new(Merchant.merchants_with_most_items(quantity))
  end

  private

  def quantity
    params.fetch(:quantity, 5).to_i
  end
end
