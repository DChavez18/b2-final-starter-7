class BulkDiscountItem < ApplicationRecord
  belongs_to :bulk_discount
  belongs_to :item
  belongs_to :invoice
end