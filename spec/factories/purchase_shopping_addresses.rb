FactoryBot.define do
  factory :purchase_shopping_address do
    token {"tok_abcdefghijk00000000000000000"}
    postal_code {'123-4567'}
    shipping_address_id {2}
    municipality {'横浜市'}
    address {1-1}
    building_name {'東京ハイツ'}
    phone_number {'09012345678'}
  end
end
