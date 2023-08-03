require "rails_helper"

RSpec.describe BulkDiscountItem do

  describe "relationships" do
    it { should belong_to(:bulk_discount)}
    it { should belong_to(:item)}
  end
end