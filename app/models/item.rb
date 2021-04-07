class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name, :unit_price
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  after_find :merchant_id_exists

  def merchant_id_exists
    !Merchant.find(merchant_id).nil?
  end

  def self.find_one_by_min_price(price)
    find_all_by_min_price(price).first
  end

  def self.find_all_by_min_price(price)
    where('unit_price >= ?',price)
    .order(:name)
  end

  def self.find_one_by_max_price(price)
    find_all_by_max_price(price).first
  end

  def self.find_all_by_max_price(price)
    where('unit_price <= ?',price)
    .order(:name)
  end
  
  def self.find_one_by_price_range(min_price, max_price)
    find_all_by_price_range(min_price, max_price).first
  end

  def self.find_all_by_price_range(min_price, max_price)
    where('unit_price >= ? and unit_price <= ?',min_price, max_price)
    .order(:name)
  end

  def self.items_with_most_revenue(quantity)
    select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions)
    .where(transactions: {result: :success})
    .group(:id)
    .order('revenue desc')
    .limit(quantity)
  end
end
