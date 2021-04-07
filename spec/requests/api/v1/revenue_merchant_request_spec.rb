require 'rails_helper'

describe "Revenue Merchant request", :realistic_error_responses do
  it 'can get merchants with the most revenue with a certain quantity' do
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

    get '/api/v1/revenue/merchants?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant_name_revenue")

      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes).to have_key(:revenue)
    end
  end
  it 'cant get merchants with most revenue when quantity as a string' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)

    get "/api/v1/revenue/merchants?quantity='asfasdf'"

    expect(response).to_not be_successful
  end
  it 'cant get merchants with most revenue when there is no quantity params' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)

    get "/api/v1/revenue/merchants"

    expect(response).to_not be_successful

    get "/api/v1/revenue/merchants?quantity="
    expect(response).to_not be_successful
  end
end
