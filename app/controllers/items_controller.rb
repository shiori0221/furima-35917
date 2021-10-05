class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]
  before_action :redirect_root, only: [:edit, :update]

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
    @comment = Comment.new
    @comments = @item.comments.includes(:user)
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_path if @item.destroy
  end

  def search
    @items = Item.search(params[:keyword]).order('created_at DESC')
    @keyword = params[:keyword]
  end

  private

  def item_params
    permit_params = params.require(:item).permit(:product, :price, :description, :status_id, :delivery_charge_id, :shipping_address_id,
                                                 :days_to_delivery_id, :category_id, images: [], images_attachments_attributes: [:id, :_destroy]).merge(user_id: current_user.id)
    images_attachments_attributes = permit_params.delete(:images_attachments_attributes)
    if images_attachments_attributes
      destroy_signed_ids = images_attachments_attributes.to_h.map do |_, attribute|
        @item.images.find_by(id: attribute[:id])&.signed_id if attribute.delete(:_destroy)
      end.compact
      permit_params[:images] -= destroy_signed_ids
    end
    permit_params
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless current_user.id == @item.user_id
  end

  def redirect_root
    redirect_to root_path if @item.purchase
  end
end
