class AddInvoiceReferenceToBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :bulk_discounts, :invoice, null: false, foreign_key: true
  end
end
