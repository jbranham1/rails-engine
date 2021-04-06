class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.merchants_with_most_items(quantity)
    select('merchants.*, count(items.id) as item_count')
    .joins(:items)
    .group(:id)
    .order('item_count desc')
    .limit(quantity)
  end
end
