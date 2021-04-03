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
        merchant2 = create(:merchant, name: 'Merchant2')
        merchant3 = create(:merchant, name: 'test')
        expect(Merchant.find_all_by_name('merch')).to eq([merchant, merchant2])
      end
    end
  end
end
