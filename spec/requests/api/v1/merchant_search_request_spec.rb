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
    get "/api/v1/merchants/find", headers: headers, params: JSON.generate({name: 'NOMATCH'})

    expect(response).to_not be_successful
  #  binding.pry

    #
    #merchant = JSON.parse(response.body, symbolize_names: true)
    #expect(merchant.error).to eq(nil);
    # expect(merchant.count).to eq(1)
    # expect(merchant[:data].count).to eq(3)
    # attributes = merchant[:data][:attributes]
    # expect(attributes).to be_a(Hash)
    # expect(merchant[:data]).to have_key(:id)
    # expect(merchant[:data][:id]).to be_a(String)
    #
    # expect(attributes).to have_key(:name)
    # expect(attributes[:name]).to be_a(String)
  end
  it "fetches all merchant by name" do
    create_list(:merchant,3, name: 'test')
    get "/api/v1/merchants/find_all", headers: headers, params: {name: 'es'}
    expect(response).to be_successful
  #
  #   merchant = JSON.parse(response.body, symbolize_names: true)
  # #  binding.pry
  #   expect(merchant[:data].count).to eq(3)
  #   attributes = merchant[:data][:attributes]
  #   expect(attributes).to be_a(Hash)
  #   expect(merchant[:data]).to have_key(:id)
  #   expect(merchant[:data][:id]).to be_a(String)
  #
  #   expect(attributes).to have_key(:name)
  #   expect(attributes[:name]).to be_a(String)
  end
  it "does not fetch all merchants by name" do
    create_list(:merchant,3)
    get "/api/v1/merchants/find", headers: headers, params: JSON.generate({name: 'NOMATCH'})

    expect(response).to_not be_successful
  #  binding.pry

    #
    #merchant = JSON.parse(response.body, symbolize_names: true)
    #expect(merchant.error).to eq(nil);
    # expect(merchant.count).to eq(1)
    # expect(merchant[:data].count).to eq(3)
    # attributes = merchant[:data][:attributes]
    # expect(attributes).to be_a(Hash)
    # expect(merchant[:data]).to have_key(:id)
    # expect(merchant[:data][:id]).to be_a(String)
    #
    # expect(attributes).to have_key(:name)
    # expect(attributes[:name]).to be_a(String)
  end
end
