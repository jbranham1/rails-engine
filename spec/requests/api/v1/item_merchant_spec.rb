require 'rails_helper'
describe "Item Merchant API" do
  it "gets an item's merchant" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant.count).to eq(1)

    attributes = merchant[:data][:attributes]
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
end
