require 'rails_helper'
describe "Merchant Search API", :realistic_error_responses do
  it "fetch one merchant by name" do
    create_list(:merchant,3, name: 'test')
    get "/api/v1/merchants/find", headers: headers, params: {name: 'es'}
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant.count).to eq(1)
    expect(merchant[:data].count).to eq(3)
    attributes = merchant[:data][:attributes]
    expect(attributes).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch one merchant by name" do
    create_list(:merchant,3)
    get "/api/v1/merchants/find", headers: headers, params: {name: 'NOMATCH'}

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(merchant[:data]).to be_a(Hash)
  end

  it "does not fetch one merchant by name when no params" do
    create_list(:merchant,3)
    get "/api/v1/merchants/find", headers: headers

    expect(response).to_not be_successful
  end
  it "fetches all merchant by name" do
    create_list(:merchant,3, name: 'test')
    get "/api/v1/merchants/find_all", headers: headers, params: {name: 'es'}
    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)
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
  it "does not fetch all merchants by name when no params" do
    create_list(:merchant,3)
    get "/api/v1/merchants/find_all", headers: headers

    expect(response).to_not be_successful
  end
end
