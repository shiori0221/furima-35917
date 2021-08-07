class PurchasesController < ApplicationController
  
  def index
    @item = Item.find(params[:item_id])
    @purchase_shopping_address = PurchaseShoppingAddress.new
  end

  def create
    @item = Item.find(params[:item_id])
    @purchase_shopping_address = PurchaseShoppingAddress.new(purchase_params)
    if @purchase_shopping_address.valid?
      pay_item
      @purchase_shopping_address.save
      redirect_to  root_path
    else
      render 'index'
    end
  end

  private

  def purchase_params
    params.require(:purchase_shopping_address).permit(:postal_code, :shipping_address_id, :municipality, :address, :building_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    Payjp::api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,
      card: purchase_params[:token],
      currency: 'jpy'
    )
  end

end
