class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.find_by_name(name)
    find_all_by_name(name).first
  end

  def self.find_all_by_name(name)
    where("name ilike ?", "%#{name}%")
  end
end
