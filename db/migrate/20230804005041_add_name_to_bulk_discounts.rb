class AddNameToBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_column :bulk_discounts, :name, :string
  end
end
