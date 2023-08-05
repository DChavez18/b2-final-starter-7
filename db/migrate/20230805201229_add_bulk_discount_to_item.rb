class AddBulkDiscountToItem < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :bulk_discount, foreign_key: true, default: nil
    Item.update_all(bulk_discount_id: nil)
  end
end
