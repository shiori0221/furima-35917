class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new
  end

  def create
    Item.create(item_params)
  end

  private
  def item_params
    params.require(:item).permit(:product, :price, :description, :status_id, :delivery_charge_id, :shippoing_address_id, :days_to_delivery_id, :category_id)
  end
end
