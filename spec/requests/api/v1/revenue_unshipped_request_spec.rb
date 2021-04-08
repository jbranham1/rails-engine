require 'rails_helper'

describe "Revenue Unshipped request", :realistic_error_responses do
  it 'can get revenue of unshipped orders with a certain quantity' do
    merchant = create(:merchant, id: 1)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice2 = create(:invoice, status: :packaged)
    invoice3 = create(:invoice, status: :packaged)
    invoice4 = create(:invoice, status: :packaged)

    create(:invoice_item, invoice: invoice, item: item, quantity:2, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item, quantity:2, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item2, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item3, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice3, item: item, quantity:4, unit_price: 2)
    create(:invoice_item, invoice: invoice3, item: item2, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice4, item: item, quantity:3, unit_price: 2)

    get '/api/v1/revenue/unshipped?quantity=2'

    expect(response).to be_successful

    unshipped = JSON.parse(response.body, symbolize_names: true)

    expect(unshipped[:data].count).to eq(2)

    unshipped[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("unshipped_order")

      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:potential_revenue)
    end
  end
  it 'can get top revenue of 10 unshipped orders when no quantity is defined' do
    merchant = create(:merchant, id: 1)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice2 = create(:invoice, status: :packaged)
    invoice3 = create(:invoice, status: :packaged)
    invoice4 = create(:invoice, status: :packaged)
    invoice5 = create(:invoice, status: :packaged)
    invoice6 = create(:invoice, status: :packaged)
    invoice7 = create(:invoice, status: :packaged)
    invoice8 = create(:invoice, status: :packaged)
    invoice9 = create(:invoice, status: :packaged)
    invoice10 = create(:invoice, status: :packaged)
    invoice11 = create(:invoice, status: :packaged)
    invoice12 = create(:invoice)

    create(:invoice_item, invoice: invoice, item: item, quantity:2, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item, quantity:2, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item2, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice2, item: item3, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice3, item: item, quantity:4, unit_price: 2)
    create(:invoice_item, invoice: invoice3, item: item2, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice4, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice5, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice6, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice7, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice8, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice9, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice10, item: item, quantity:3, unit_price: 2)
    create(:invoice_item, invoice: invoice11, item: item, quantity:1, unit_price: 2)

    get '/api/v1/revenue/unshipped'

    expect(response).to be_successful

    unshipped = JSON.parse(response.body, symbolize_names: true)

    expect(unshipped[:data].count).to eq(10)

    unshipped[:data].each do |merchant|
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("unshipped_order")

      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(attributes).to have_key(:potential_revenue)
    end
  end
  it 'cant get revenue of unshipped orders when quantity as a string' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)

    get "/api/v1/revenue/unshipped?quantity='asfasdf'"

    expect(response).to_not be_successful
  end
  it 'cant get revenue of unshipped orders when there is no quantity params' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice, item: item)
    invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
    invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
    transaction = create(:transaction, invoice: invoice, result: :success)

    get "/api/v1/revenue/unshipped?quantity="
    expect(response).to_not be_successful
  end
end
