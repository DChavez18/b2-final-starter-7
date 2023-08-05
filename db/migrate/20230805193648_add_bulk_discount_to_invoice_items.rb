class AddBulkDiscountToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoice_items, :bulk_discount, null: true, foreign_key: true
  end
end
