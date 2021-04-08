require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0)}
  end

  describe 'class methods' do
    describe "::find_by_name" do
      it "finds an item by name" do
        item = create(:item, name: 'Item 1')
        item2 = create(:item, name: 'A Item 2')
        expect(Item.find_by_name('item')).to eq(item2)
      end
    end
    describe "::find_all_by_name" do
      it "finds all items by name" do
        item = create(:item, name: 'Item 1')
        item2 = create(:item, name: 'Item 2')
        item3 = create(:item, name: 'test')
        expect(Item.find_all_by_name('item')).to eq([item, item2])
      end
    end
    describe "::find_by_min_price" do
      it "finds an item by min price" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test')
        expect(Item.find_one_by_min_price(2)).to eq(item2)
      end
    end
    describe "::find_all_by_min_price" do
      it "finds all items by min price" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test', unit_price: 1)
        expect(Item.find_all_by_min_price(2)).to eq([item2, item])
      end
    end
    describe "::find_by_max_price" do
      it "finds an item by max price" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test')
        expect(Item.find_one_by_max_price(2)).to eq(item2)
      end
    end
    describe "::find_all_by_max_price" do
      it "finds all items by max price" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test', unit_price: 3)
        expect(Item.find_all_by_max_price(2)).to eq([item2, item])
      end
    end
    describe "::find_one_by_price_range" do
      it "finds an item by price range" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test')
        expect(Item.find_one_by_price_range(1,3)).to eq(item2)
      end
    end
    describe "::find_all_by_price_range" do
      it "finds all items by price range" do
        item = create(:item, name: 'Item 1', unit_price: 2)
        item2 = create(:item, name: 'A Item 2', unit_price: 2)
        item3 = create(:item, name: 'test', unit_price: 3)
        expect(Item.find_all_by_price_range(2,4)).to eq([item2, item, item3])
      end
    end
    describe "::items_with_most_revenue" do
      it "finds items with most revenue" do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, invoice: invoice, item: item, quantity: 7)
        invoice_item2 = create(:invoice_item, invoice: invoice, item: item2)
        invoice_item3 = create(:invoice_item, invoice: invoice, item: item3)
        transaction = create(:transaction, invoice: invoice, result: :success)
        item4 = create(:item, merchant: merchant)
        item5 = create(:item, merchant: merchant)
        item6 = create(:item, merchant: merchant)
        invoice_item4 = create(:invoice_item, invoice: invoice, item: item4, quantity: 10)
        invoice_item5 = create(:invoice_item, invoice: invoice, item: item5, quantity: 9)
        invoice_item6 = create(:invoice_item, invoice: invoice, item: item6, quantity: 8)

        items = Item.items_with_most_revenue(4)
        expect(items).to eq([item4, item5, item6, item])

        expect(items.first.revenue.to_f).to eq(99.9)
      end
    end
  end
end
