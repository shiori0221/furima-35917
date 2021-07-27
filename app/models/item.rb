class Item < ApplicationRecord
  
  with_options presence: true do
    validates :product
    validates :price
    validates :description
    validates :status_id
    validates :delivery_charge_id
    validates :shipping_address_id
    validates :days_to_delivery_id
    validates :category_id
  end
end
