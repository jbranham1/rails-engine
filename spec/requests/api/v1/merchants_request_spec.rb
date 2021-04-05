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
end
