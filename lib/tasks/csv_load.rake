require "csv"
namespace :csv_load do
   task :customers => :environment do
      CSV.foreach("db/data/customers.csv", headers: true) do |row|
         Customer.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("customers")
      puts "Customers imported."
   end

   task :merchants => :environment do
      CSV.foreach("db/data/merchants.csv", headers: true) do |row|
         Merchant.create!(row.to_hash)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("merchants")
      puts "Merchants imported."
   end

   task :items => :environment do
      CSV.foreach("db/data/items.csv", headers: true) do |row|
         Item.create!(id: row.to_hash["id"], name: row.to_hash["name"], description: row.to_hash["description"], unit_price: row.to_hash["unit_price"].to_f / 100, created_at: row.to_hash["created_at"], updated_at: row.to_hash["updated_at"], merchant_id: row.to_hash["merchant_id"], status: 1)
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("items")
      puts "Items imported."
      end

   task :invoices => :environment do
      CSV.foreach("db/data/invoices.csv", headers: true) do |row|
         if row.to_hash["status"] == "cancelled"
            status = 0
         elsif row.to_hash["status"] == "in progress"
            status = 1
         elsif row.to_hash["status"] == "completed"
            status = 2
         end
         Invoice.create!({ id:          row[0],
                           customer_id: row[1],
                           status:      status,
                           created_at:  row[4],
                           updated_at:  row[5] })
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("invoices")
      puts "Invoices imported."
   end

   task :transactions => :environment do
      CSV.foreach("db/data/transactions.csv", headers: true) do |row|
         if row.to_hash["result"] == "failed"
            result = 0
         elsif row.to_hash["result"] == "success"
            result = 1
         end
         Transaction.create!({ id:                          row[0],
                              invoice_id:                  row[1],
                              credit_card_number:          row[2],
                              credit_card_expiration_date: row[3],
                              result:                      result,
                              created_at:                  row[5],
                              updated_at:                  row[6] })
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("transactions")
      puts "Transactions imported."
   end

   task :invoice_items => :environment do
      CSV.foreach("db/data/invoice_items.csv", headers: true) do |row|
         if row.to_hash["status"] == "pending"
            status = 0
         elsif row.to_hash["status"] == "packaged"
            status = 1
         elsif row.to_hash["status"] == "shipped"
            status = 2
         end
         InvoiceItem.create!({ id:          row[0],
                              item_id:     row[1],
                              invoice_id:  row[2],
                              quantity:    row[3],
                              unit_price:  row[4],
                              status:      status,
                              created_at:  row[6],
                              updated_at:  row[7] })
      end
      ActiveRecord::Base.connection.reset_pk_sequence!("invoice_items")
      puts "InvoiceItems imported."
   end

   task :bulk_discounts => :environment do
      CSV.foreach("db/data/bulk_discounts.csv", headers: true) do |row|
        merchant_name = row.to_hash["merchant_name"]
        merchant = Merchant.find_by(name: merchant_name)
        if merchant
          BulkDiscount.create!({
            name: row.to_hash["name"],
            percentage_discount: row.to_hash["percentage_discount"],
            quantity_threshold: row.to_hash["quantity_threshold"],
            merchant: merchant
          })
        else
          puts "Merchant '#{merchant_name}' not found. Skipping bulk discount creation."
        end
      end
      puts "Bulk Discounts imported."
    end

    task :associate_bulk_discounts => :environment do
      CSV.foreach("db/data/invoice_bulk_discounts.csv", headers: true) do |row|
        invoice_id = row.to_hash["invoice_id"]
        bulk_discount_id = row.to_hash["bulk_discount_id"]
        invoice_item_id = row.to_hash["invoice_item_id"]
    
        invoice_item = InvoiceItem.find_by(id: invoice_item_id)
        bulk_discount = BulkDiscount.find_by(id: bulk_discount_id)
    
        if invoice_item && bulk_discount
          invoice_item.update(bulk_discount: bulk_discount)
          puts "Associated bulk discount #{bulk_discount_id} with invoice item #{invoice_item_id}."
        else
          puts "Failed to associate bulk discount with invoice item: #{row.inspect}"
        end
      end
      puts "Bulk Discounts associated with invoice items."
    end

   task :all do 
      [:customers, :invoices, :merchants, :items, :invoice_items, :transactions, :bulk_discounts, :associate_bulk_discounts].each do |task|
         Rake::Task["csv_load:#{task}".to_sym].invoke
      end
   end

end