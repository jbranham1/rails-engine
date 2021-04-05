class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name].nil? || params[:name] == ''
      render json: '', status: :bad_request
    else
       merchant = Merchant.find_by_name(params[:name])
      if merchant
         render json: MerchantSerializer.new(merchant)
       else
         render json: {:error => nil, :data => Hash}
      end
    end
  end

  def find_all
    if params[:name].nil? || params[:name] == ''
      render json: '', status: :bad_request
    else
      render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
    end
  end
end
