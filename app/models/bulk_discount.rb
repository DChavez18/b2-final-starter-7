class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  belongs_to :invoice
  has_many :bulk_discount_items
  has_many :items, through: :bulk_discount_items
end