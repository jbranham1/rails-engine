class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page]
      merchant = Merchant.all.find_page_limit(params[:page])
    elsif params[:per_page]
      merchant = Merchant.all.find_page_limit(1,params[:per_page])
    else
      merchant = Merchant.all
    end
    render json: MerchantSerializer.new(merchant)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end
