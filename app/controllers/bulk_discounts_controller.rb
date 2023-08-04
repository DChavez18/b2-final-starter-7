class BulkDiscountsController < ApplicationController
  
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = BulkDiscount.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
      @merchant = Merchant.find(params[:merchant_id])
      @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if @bulk_discount.save
      flash[:notice] = "Bulk discount successfully created!"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.now[:alert] = "Failed to create the bulk discount."
      render :new
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage_discount, :quantity_threshold)
  end
end