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
      flash[:success] = "Bulk discount successfully created!"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.now[:error] = "Failed to create the bulk discount."
      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.destroy

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])

    if @bulk_discount.update(bulk_discount_params)
      flash[:success] = "Bulk discount successfully updated!"
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash.now[:error] = "Failed to update the bulk discount."
      render :edit
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage_discount, :quantity_threshold)
  end
end