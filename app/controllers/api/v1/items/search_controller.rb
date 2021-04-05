class Api::V1::Items::SearchController < ApplicationController
  def find
    if params[:name].nil? || params[:name] == ''
      render json: '', status: 400
    else
      render json: ItemSerializer.new(Item.find_by_name(params[:name]))
      # merchant = Item.find_by_name(params[:name])
      # if merchant
      #   render json: ItemSerializer.new(merchant)
      # else
        #render serializer: ItemSerializer, json: {:error => nil, :data => merchant}
        #render_nil
        #render :json => errors.add(:msiisdn, {code: 101, message: "cannot be blank"})
      #end
    end
  end

  def find_all
    if params[:name].nil? || params[:name] == ''
      render json: '', status: 400
    else
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    end
  end
end
