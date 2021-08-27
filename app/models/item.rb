class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :status
  belongs_to :delivery_charge
  belongs_to :shipping_address
  belongs_to :days_to_delivery

  has_one_attached :image
  belongs_to :user
  has_one :purchase
  has_many :comments

  with_options presence: true do
    validates :product, length: { maximum: 40 }
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
    validates :description, length: { maximum: 1000 }
    validates :image
  end
  with_options numericality: { other_than: 1 } do
    validates :status_id
    validates :delivery_charge_id
    validates :shipping_address_id
    validates :days_to_delivery_id
    validates :category_id
  end

  def self.search(search)
    if search != ''
      Item.where('product LIKE(?) OR description LIKE(?)', "%#{search}%", "%#{search}%")
    else
      Item.all
    end
  end
end
