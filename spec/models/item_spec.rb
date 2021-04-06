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
      it "finds all item by name" do
        item = create(:item, name: 'Item 1')
        item2 = create(:item, name: 'Item 2')
        item3 = create(:merchant, name: 'test')
        expect(Item.find_all_by_name('item')).to eq([item, item2])
      end
    end
  end
end
