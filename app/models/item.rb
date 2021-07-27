class Item < ApplicationRecord
  with_options presence: true do
    validates :produce
    validates :price
    validates :description
    validates :status_id
    validates :delivery_charge_id
    validates :shippoing_address_id
    validates :days_to_delivery_id
    validates :category_id
  end
end
