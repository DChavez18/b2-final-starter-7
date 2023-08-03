require "rails_helper"

RSpec.describe BulkDiscount do

  describe "relationships" do
    it { should belong_to(:merchant)}
    it { should have_many(:bulk_discount_items)}
    it { should have_many(:items).through(:bulk_discount_items)}
  end
end
