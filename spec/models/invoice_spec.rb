require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
    it { should have_many(:bulk_discount_items)}
    it { should have_many(:bulk_discounts).through(:bulk_discount_items)}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "#total_disocunted_revenue" do
      merchant = Merchant.create!(name: 'Hair Care')
      bulk_discount = BulkDiscount.create!(name: "Summer Sale", percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant.id)
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, bulk_discount: bulk_discount)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: "in_progress", created_at: "2012-03-27 14:54:09")
      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 2)

      discounted_revenue = invoice_1.total_discounted_revenue

      expect(discounted_revenue).to eq(90)
    end
  end

  # describe "class methods" do
  #   describe "#total_discounted_revenue" do
  #     it "calculates the total discounted revenue for a specific invoice" do
  #       merchant = Merchant.create!(name: 'Hair Care')
  #       bulk_discount = BulkDiscount.create!(name: "Summer Sale", percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant.id)
  #       item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, bulk_discount: bulk_discount)
  #       customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
  #       invoice_1 = Invoice.create!(customer_id: customer_1.id, status: "in_progress", created_at: "2012-03-27 14:54:09")
  #       invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
        
  #       discounted_revenue = Invoice.total_discounted_revenue(invoice_1.id)
       
  #       expect(discounted_revenue).to eq(81)
  #     end
  #   end
  # end
end
