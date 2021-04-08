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

  describe 'class methods' do
    describe "::unshipped_revenue" do
      it "gets top the most unshipped revenue for invoices with a limit param" do
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

        unshipped_invoices = Invoice.unshipped_revenue(2)
        expect(unshipped_invoices).to eq ([invoice2, invoice3])

        first_invoice = unshipped_invoices.first
        expect(first_invoice.potential_revenue).to eq (16)
      end
    end
  end
end
