require 'rails_helper'
describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant,3)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    attributes = merchant[:attributes]
    expect(attributes).to be_a(Hash)
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end

  it 'can get the page number' do
    create_list(:merchant,25)
    get '/api/v1/merchants?page=1'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)

    merchants[:data].each do |merchant|
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  it 'can get the page number 1 if page is 0 or lower' do
    create_list(:merchant,25)
    get '/api/v1/merchants?page=0'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)

    merchants[:data].each do |merchant|
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  it 'can get an empty array 1 if there is no data on the page' do
    get '/api/v1/merchants?page=1'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(0)
  end

  it 'can get the page 1 and per page count' do
    create_list(:merchant,100)
    get '/api/v1/merchants?per_page=50'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(50)

    merchants[:data].each do |merchant|
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end
  it 'can get merchants with the most items and returns 5 by default' do
    merchant = create(:merchant,id: 1)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)
    merchant2 = create(:merchant,id: 2)

    get '/api/v1/merchants/most_items'

    expect(response).to_not be_successful

  end
  it 'can get merchants with the most items with a certain quantity' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)
    merchant2 = create(:merchant)
    item4 = create(:item, merchant: merchant2)
    item5 = create(:item, merchant: merchant2)
    item6 = create(:item, merchant: merchant2)
    invoice2 = create(:invoice)
    invoice_item4 = create(:invoice_item, invoice: invoice2, item: item4)
    invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5)
    invoice_item6 = create(:invoice_item, invoice: invoice2, item: item6)
    transaction2 = create(:transaction, invoice: invoice2, result: :success)
    merchant3 = create(:merchant)
    create_list(:item, 5, merchant: merchant3)
    merchant4 = create(:merchant)
    create_list(:item, 3, merchant: merchant4)
    merchant5 = create(:merchant)
    create_list(:item, 3, merchant: merchant5)
    create_list(:merchant, 5)

    get '/api/v1/merchants/most_items?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("items_sold")

      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes).to have_key(:count)
      expect(attributes[:count]).to be_a(Integer)
    end
  end
  it 'cant get merchants with most items when quantity as a string' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)

    get "/api/v1/merchants/most_items?quantity='asfasdf"

    expect(response).to_not be_successful
  end
end
