class Api::V1::ItemsController < ApplicationController
  def index
    if params[:page]
      item = Item.all.find_page_limit(params[:page])
    elsif params[:per_page]
      item = Item.all.find_page_limit(1,params[:per_page])
    else
      item = Item.all
    end
    render json: ItemSerializer.new(item)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item).serialized_json, status: :created
  end

  def update
    #Merchant.find(item_params[:merchant_id])
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item).serialized_json
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
