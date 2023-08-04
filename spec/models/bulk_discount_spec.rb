require "rails_helper"

RSpec.describe BulkDiscount do

  describe "relationships" do
    it { should belong_to(:merchant)}
    it { should have_many(:bulk_discount_items)}
    it { should have_many(:items).through(:bulk_discount_items)}
    it { should have_many(:invoices).through(:bulk_discount_items)}
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :quantity_threshold }
  end
end
