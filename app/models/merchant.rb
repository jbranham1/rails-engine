class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.merchants_with_most_items(quantity)
    select('merchants.*, sum(invoice_items.quantity) as count')
    .joins(:transactions)
    .where("transactions.result = 'success'")
    .group(:id)
    .order('count desc')
    .limit(quantity)
  end

  def self.merchants_with_most_revenue(quantity)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions)
    .where(transactions: {result: :success})
    .group(:id)
    .order('revenue desc')
    .limit(quantity)
  end
end
