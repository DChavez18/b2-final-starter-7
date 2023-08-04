require "rails_helper"

RSpec.describe "bulk discounts index", type: :feature do
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

# 2: Merchant Bulk Discount Create
# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed

  describe "when i visit my bulk discounts index" do
    it "displays a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant1)
      
      expect(page).to have_link("Create New Discount")
    end
    
    it "takes me to a new page when the link is clicked and I see a form to add a new bulk discount" do
      visit merchant_bulk_discounts_path(@merchant1)

      click_link "Create New Discount"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
      expect(page).to have_field("bulk_discount_name")
      expect(page).to have_field("bulk_discount_percentage_discount")
      expect(page).to have_field("bulk_discount_quantity_threshold")
      expect(page).to have_button("Create Bulk Discount")
    end

    it "redirects me back to bulk discount index when i click the create new discount button after I fill in the form and I see the new discount" do
      visit new_merchant_bulk_discount_path(@merchant1)

      fill_in "Name", with: "Summer Sale"
      fill_in "Percentage discount", with: 20
      fill_in "Quantity threshold", with: 10

      click_button "Create Bulk Discount"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to have_content("Summer Sale - 20% off 10 items")
    end
  end

# 3: Merchant Bulk Discount Delete
# As a merchant
# When I visit my bulk discounts index
# Then next to each bulk discount I see a link to delete it
# When I click this link
# Then I am redirected back to the bulk discounts index page
# And I no longer see the discount listed

  describe "when i visit my bulk discounts index" do
    it "displays a link next to each discount to delete it" do
      visit merchant_bulk_discounts_path(@merchant1)
      
      page.all(".bulk-discount").each do |bulk_discount_element|
        within(bulk_discount_element) do
          expect(page).to have_button("Delete")
        end
      end
    end
    
    it "deletes the discount when the button is clicked and then redirects user back to that merchant's bulk_discount index page" do
      visit merchant_bulk_discounts_path(@merchant1)

      expect(page).to have_content(@bulk_discount1.name)
      expect(page).to have_content(@bulk_discount2.name)
      expect(page).to have_content(@bulk_discount3.name)

      first('.bulk-discount').click_button("Delete")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to_not have_content(@bulk_discount1.name)
      expect(page).to have_content(@bulk_discount2.name)
      expect(page).to have_content(@bulk_discount3.name)
    end
  end
end