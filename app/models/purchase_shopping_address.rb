class PurchaseShoppingAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :shipping_address_id, :municipality, :address, :building_name, :phone_number, :user_id, :item_id,
                :token

  with_options presence: true do
    validates :token
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ }
    validates :shipping_address_id, numericality: { other_than: 1 }
    validates :municipality
    validates :address
    validates :phone_number, format: { with: /\A[0-9]+\z/ }, length: { minimum: 10, maximum: 11 }
    validates :user_id
    validates :item_id
  end

  def save
    purchase = Purchase.create(user_id: user_id, item_id: item_id)
    ShoppingAddress.create(postal_code: postal_code, shipping_address_id: shipping_address_id, municipality: municipality,
                           address: address, building_name: building_name, phone_number: phone_number, purchase_id: purchase.id)
  end
end
