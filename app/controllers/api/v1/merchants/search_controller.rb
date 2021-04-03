class Api::V1::Merchants::SearchController < ApplicationController
  def find
    merchant = Merchant.find_by_name(params[:name])
  #  if merchant
      render json: MerchantSerializer.new(merchant)
  end

  def find_all
    render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
  end
end
