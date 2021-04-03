class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.find_page_limit(page, per_page))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item).serialized_json, status: :created
  end

  def update
    item = Item.find(params[:id])
    #binding.pry
    #if item.merchant_id_exists
      item.update!(item_params)
      render json: ItemSerializer.new(item).serialized_json
    # else
    #   binding.pry
    #   render_404
    # end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
