require 'rails_helper'
RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  describe 'class methods' do
    describe "::find_by_name" do
      it "finds a merchant by name" do
        merchant = create(:merchant, name: 'Merchant')
        merchant2 = create(:merchant, name: 'Merchant2')
        expect(Merchant.find_by_name('merch')).to eq(merchant)
      end
    end
    describe "::find_all_by_name" do
      it "finds all merchant by name" do
        merchant = create(:merchant, name: 'Merchant')
        merchant2 = create(:merchant, name: ' AMerchant2')
        merchant3 = create(:merchant, name: 'test')
        expect(Merchant.find_all_by_name('merch')).to eq([merchant2, merchant])
      end
    end
    describe "::merchants_with_most_items" do
      it "finds merchants with most items" do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, invoice: invoice, item: item)
        invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
        invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
        transaction = create(:transaction, invoice: invoice, result: :success)
        merchant2 = create(:merchant, id: 2)
        item4 = create(:item, merchant: merchant2)
        item5 = create(:item, merchant: merchant2)
        item6 = create(:item, merchant: merchant2)
        invoice2 = create(:invoice)
        invoice_item4 = create(:invoice_item, invoice: invoice2, item: item4)
        invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5)
        invoice_item6 = create(:invoice_item, invoice: invoice2, item: item6)
        transaction2 = create(:transaction, invoice: invoice2, result: :success)
        merchant3 = create(:merchant,id: 3)
        item7 = create(:item, merchant: merchant3)
        item8 = create(:item, merchant: merchant3)
        invoice3 = create(:invoice)
        invoice_item7 = create(:invoice_item, invoice: invoice3, item: item7)
        invoice_item8 = create(:invoice_item, invoice: invoice3, item: item8)
        transaction3 = create(:transaction, invoice: invoice3, result: :success)
        merchant4 = create(:merchant,id: 4)
        item9 = create(:item, merchant: merchant4)
        invoice4 = create(:invoice)
        invoice_item4 = create(:invoice_item, invoice: invoice4, item: item9)
        transaction2 = create(:transaction, invoice: invoice4, result: :success)
        merchant5 = create(:merchant,id: 5)
        item10 = create(:item, merchant: merchant5)
        invoice5 = create(:invoice)
        invoice_item5 = create(:invoice_item, invoice: invoice5, item: item10)
        transaction2 = create(:transaction, invoice: invoice5, result: :success)
        merchant6 = create(:merchant)

        merchants = Merchant.merchants_with_most_items(4)
        expect(merchants).to eq([merchant, merchant2, merchant3, merchant4])

        expect(merchants.first.count).to eq(3)
      end
    end
    describe "::merchants_with_most_revenue" do
      it "finds merchants with most revenue" do
        merchant = create(:merchant,id: 4)
        item9 = create(:item, merchant: merchant)
        invoice4 = create(:invoice)
        invoice_item4 = create(:invoice_item, invoice: invoice4, item: item9)
        transaction2 = create(:transaction, invoice: invoice4, result: :success)
        merchant2 = create(:merchant, id: 2)
        item4 = create(:item, merchant: merchant2)
        item5 = create(:item, merchant: merchant2)
        item6 = create(:item, merchant: merchant2)
        invoice2 = create(:invoice)
        invoice_item4 = create(:invoice_item, invoice: invoice2, item: item4)
        invoice_item5 = create(:invoice_item, invoice: invoice2, item: item5)
        invoice_item6 = create(:invoice_item, invoice: invoice2, item: item6)
        transaction2 = create(:transaction, invoice: invoice2, result: :success)
        merchant3 = create(:merchant,id: 3)
        item7 = create(:item, merchant: merchant3)
        item8 = create(:item, merchant: merchant3)
        invoice3 = create(:invoice)
        invoice_item7 = create(:invoice_item, invoice: invoice3, item: item7)
        invoice_item8 = create(:invoice_item, invoice: invoice3, item: item8)
        transaction3 = create(:transaction, invoice: invoice3, result: :success)
        merchant4 = create(:merchant, id: 1)
        item = create(:item, merchant: merchant4)
        item2 = create(:item, merchant: merchant4)
        item3 = create(:item, merchant: merchant4)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, invoice: invoice, item: item)
        invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
        invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
        transaction = create(:transaction, invoice: invoice, result: :success)
        merchant5 = create(:merchant,id: 5)
        item10 = create(:item, merchant: merchant5)
        invoice5 = create(:invoice)
        invoice_item5 = create(:invoice_item, invoice: invoice5, item: item10)
        transaction2 = create(:transaction, invoice: invoice5, result: :success)
        merchant6 = create(:merchant)

        merchants = Merchant.merchants_with_most_revenue(4)
        expect(merchants).to eq([merchant4, merchant2, merchant3, merchant])

        expect(merchants.first.revenue.to_f).to eq(29.97)
      end
    end
  end
end
