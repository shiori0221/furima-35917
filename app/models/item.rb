class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :status
  belongs_to :delivery_charge
  belongs_to :shipping_address
  belongs_to :days_to_delivery

  with_options presence: true do
    validates :product
    validates :price
    validates :description
  end
  with_options numericality: { other_than: 1, message: "can't be blank"} do
    validates :status_id
    validates :delivery_charge_id
    validates :shipping_address_id
    validates :days_to_delivery_id
    validates :category_id
  end
end
