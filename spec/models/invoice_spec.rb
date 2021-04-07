require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
    it {should belong_to :merchant}
  end

  describe 'instance methods' do
    describe "#revenue" do
      it "gets revenue for an invoice item" do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, invoice: invoice, item: item, quantity:1, unit_price: 2)
        expect(invoice_item.revenue).to eq (2.00)
      end
    end
  end
end
