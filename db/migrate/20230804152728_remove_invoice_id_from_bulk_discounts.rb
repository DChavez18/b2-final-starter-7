class RemoveInvoiceIdFromBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bulk_discounts, :invoice_id, :bigint
  end
end
