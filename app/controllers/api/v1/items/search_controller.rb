class Api::V1::Items::SearchController < ApplicationController
  def find
    if params[:name].nil? || params[:name] == ''
      render json: '', status: 400
    else
      item = Item.find_by_name(params[:name])
      if item
         render json: ItemSerializer.new(item)
       else
         render json: {:error => nil, :data => Hash}
      end
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
