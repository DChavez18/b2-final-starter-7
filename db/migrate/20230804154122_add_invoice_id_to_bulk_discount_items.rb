class AddInvoiceIdToBulkDiscountItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :bulk_discount_items, :invoice, null: false, foreign_key: true
  end
end
