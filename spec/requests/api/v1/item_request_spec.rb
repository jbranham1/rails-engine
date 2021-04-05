require 'rails_helper'
describe "Items API" do
  it "sends a list of items" do
    item = create_list(:item, 3)

    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(String)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)

    end
  end

  it "can get one merchant by its id" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    attributes = item[:attributes]
    expect(attributes).to be_a(Hash)
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(String)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_a(Integer)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
                    id: 1,
                    name: 'item',
                    description: 'description',
                    unit_price: 123.45,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    expect(response).to have_http_status(:created)
    item = JSON.parse(response.body, symbolize_names: true)
  end

  it "can won't create a new item with missing information" do
    merchant = create(:merchant)
    item_params = ({
                    id: 1,
                    name: 'item',
                    description: 'description',
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to have_http_status(:not_found)
  end

  it "can update an existing item" do
    merchant = create(:merchant, id:1)
    id = create(:item, merchant: merchant).id
    previous_name = Item.last.name
    item_params = { name: "New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
    #binding.pry
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("New Name")
  end

  it "can't update an item that doesn't exist" do
    item_params = { name: "New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}

    #patch "/api/v1/items/#{99999999}", headers: headers, params: JSON.generate({item: item_params})
    #expect(response).to_not be_successful
  #  expect(response).to have_http_status(:bad_request)
    #expect(response.code).to eq("404")
  end

  it "can't update an existing item with a bad merchant ID" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id
    item_params = ({
                    id: 1,
                    name: 'item',
                    description: 'description',
                    unit_price: 123.45,
                    merchant_id: '999999999999999'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to_not be_successful
    expect(response.code).to eq("404")
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)


    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{InvoiceItem.find(invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can destroy an item but keeps invoice with multiple items" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)
    invoice_item = create(:invoice_item, item: item2, invoice: invoice)


    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(Invoice.find(invoice.id)).to eq(invoice)
  end

  it 'can get the page number' do
    merchant = create(:merchant)
    items = create_list(:item, 20, merchant: merchant)
    get '/api/v1/items?page=1'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
  end

  it 'can get the page number 1 if page is 0 or lower' do
    merchant = create(:merchant)
    items = create_list(:item, 25, merchant: merchant)
    get '/api/v1/items?page=0'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
  end
  it 'can get the page 1 and per page count' do
    merchant = create(:merchant)
    items = create_list(:item, 100, merchant: merchant)
    get '/api/v1/items?per_page=50'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(50)
  end
end
