class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :bulk_discount_items
  has_many :items, through: :bulk_discount_items
  has_many :invoices, through: :bulk_discount_items

  validates_presence_of :name, :percentage_discount, :quantity_threshold
end