require "rails_helper"

RSpec.describe "bulk discount show page", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    # @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    # @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    # @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    # @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    # @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    # @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    # @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    # @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    # @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    # @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    # @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    # @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    # @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    # @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    # @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    # @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    # @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    # @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discount1 = FactoryBot.create(:bulk_discount, merchant: @merchant1)
    @bulk_discount2 = FactoryBot.create(:bulk_discount, merchant: @merchant1)
    @bulk_discount3 = FactoryBot.create(:bulk_discount, merchant: @merchant1)
  end

# 4: Merchant Bulk Discount Show
# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and 
# percentage discount

  describe "when i visit my bulk discounts show page" do
    it "displays that discount's quantity threshold and percentage discount" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      
      expect(page).to have_content("Quantity Threshold: #{@bulk_discount1.quantity_threshold}")
      expect(page).to have_content("Percentage Discount: #{@bulk_discount1.percentage_discount}")
    end
  end
  
  # 5: Merchant Bulk Discount Edit
  # As a merchant
  # When I visit my bulk discount show page
  # Then I see a link to edit the bulk discount
  # When I click this link
  # Then I am taken to a new page with a form to edit the discount
  # And I see that the discounts current attributes are 
  # pre-poluated in the form
  # When I change any/all of the information and click submit
  # Then I am redirected to the bulk discount's show page
  # And I see that the discount's attributes have been updated
  
  describe "when i visit my bulk discounts show page" do
    it "displays a link to edit the bulk discount" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      
      expect(page).to have_link("Edit")
    end
    
    it "takes me to new page with a form to edit the discount with its info prepopulated when the link is clicked" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      
      click_link "Edit"
      
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1))
      expect(page).to have_selector("form")
      expect(page).to have_field("bulk_discount_name", with: @bulk_discount1.name)
      expect(page).to have_field("bulk_discount_percentage_discount", with: @bulk_discount1.percentage_discount)
      expect(page).to have_field("bulk_discount_quantity_threshold", with: @bulk_discount1.quantity_threshold)
    end
    
    it "redirects me to the discounts show page when I fill in the form correctly and I click the update button, where I see updated info" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      
      click_link "Edit"
      
      fill_in "Name", with: "Sale"
      fill_in "Percentage discount", with: 10
      fill_in "Quantity threshold", with: 5
      
      click_button "Update Bulk Discount"
      
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1))
      expect(page).to have_content("Sale")
      expect(page).to have_content(10)
      expect(page).to have_content(5)
    end
    
    it "shows a unsuccesful message when all areas aren't filled in correctly" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      
      click_link "Edit"
      
      fill_in "Name", with: ""
      fill_in "Percentage discount", with: "0"
      fill_in "Quantity threshold", with: ""

      click_button "Update Bulk Discount"

      expect(page).to have_content("Failed to update the bulk discount.")
    end
  end
end