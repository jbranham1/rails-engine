require 'rails_helper'
describe "Item Search API", :realistic_error_responses do
  it "fetch one item by name" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find", headers: headers, params: {name: 'es'}
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq(1)
    expect(item[:data].count).to eq(3)
    attributes = item[:data][:attributes]
    expect(attributes).to be_a(Hash)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch one item by name" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {name: 'NOMATCH'}

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data]).to be_a(Hash)
  end

  it "does not fetch one item by name when no params" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers

    expect(response).to_not be_successful
  end
  it "fetches all item by name" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find_all", headers: headers, params: {name: 'es'}
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end
  it "does not fetch all items by name when no params" do
    create_list(:item,3)
    get "/api/v1/items/find_all", headers: headers

    expect(response).to_not be_successful
  end
  it "fetch one item by min price" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find", headers: headers, params: {min_price: 9.99}
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq(1)
    expect(item[:data].count).to eq(3)
    attributes = item[:data][:attributes]
    expect(attributes).to be_a(Hash)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch one item by min price" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {min_price: 2}

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data]).to be_a(Hash)
  end
  it "fetches all items by min price" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find_all", headers: headers, params: {min_price: 9.99}
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end
  it "fetch one item by max price" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find", headers: headers, params: {max_price: 12}
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq(1)
    expect(item[:data].count).to eq(3)
    attributes = item[:data][:attributes]
    expect(attributes).to be_a(Hash)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch one item by max price" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {max_price: 2}

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data]).to be_a(Hash)
  end
  it "fetches all items by max price" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find_all", headers: headers, params: {max_price: 12}
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end
  it "fetch one item by price range" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find", headers: headers, params: {min_price: 2, max_price: 50}
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq(1)
    expect(item[:data].count).to eq(3)
    attributes = item[:data][:attributes]
    expect(attributes).to be_a(Hash)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch one item by price range" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {min_price: 2, max_price: 2}

    expect(response).to be_successful
    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data]).to be_a(Hash)
  end
  it "fetches all items by price range" do
    create_list(:item,3, name: 'test')
    get "/api/v1/items/find_all", headers: headers, params: {min_price: 2, max_price: 50}
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end
  it "returns error if min price is larger than max price" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {min_price: 4, max_price: 2}

    expect(response).to_not be_successful
  end
  it "returns error if price and name are both passed in" do
    create_list(:item,3)
    get "/api/v1/items/find", headers: headers, params: {name: 'test', max_price: 2}

    expect(response).to_not be_successful
  end
end
