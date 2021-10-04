FactoryBot.define do
  factory :item do
    product               { Faker::Name.name }
    price                 { Faker::Commerce.price(range: 300..9_999_999) }
    description           { Faker::Lorem.sentence }
    status_id             { 2 }
    delivery_charge_id    { 2 }
    shipping_address_id   { 2 }
    days_to_delivery_id   { 2 }
    category_id           { 2 }
    association :user

    after(:build) do |item|
      item.images.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
