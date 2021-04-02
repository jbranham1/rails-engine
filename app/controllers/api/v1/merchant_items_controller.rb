class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end
