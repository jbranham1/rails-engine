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
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    delete_invoice(item)
    render json: Item.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def delete_invoice(item)
    item.invoices.each do |invoice|
      invoice.destroy if invoice.items.all? { |invoice_item| invoice_item == item}
    end
  end
end
