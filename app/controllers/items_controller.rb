class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, only: [:edit, :update]

  def index
    @items = Item.includes(:user).order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:product, :price, :description, :status_id, :delivery_charge_id, :shipping_address_id,
                                 :days_to_delivery_id, :category_id, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless current_user.id == Item.find(params[:id]).user_id
      redirect_to root_path
    end
  end
end
