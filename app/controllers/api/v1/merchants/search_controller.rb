class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name].nil? || params[:name] == ''
      render json: '', status: 400
    else
      render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]))
      # merchant = Merchant.find_by_name(params[:name])
      # if merchant
      #   render json: MerchantSerializer.new(merchant)
      # else
        #render serializer: MerchantSerializer, json: {:error => nil, :data => merchant}
        #render_nil
        #render :json => errors.add(:msiisdn, {code: 101, message: "cannot be blank"})
      #end
    end
  end

  def find_all
    if params[:name].nil? || params[:name] == ''
      render json: '', status: 400
    else
      render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
    end
  end
end
