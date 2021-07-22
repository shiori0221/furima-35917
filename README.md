## usersテーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| encrypted_password | string | null: false               |
| email              | string | null: false, unique: true |
| lastname           | string | null: false               |
| firstname          | string | null: false               |
| lastname_kana      | string | null: false               |
| firstname_kana     | string | null: false               |
| birthday           | date   | null: false               |

### Association

has_many :items
has_many :purchases

## itemsテーブル

| Column               | ype       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| product             | string     | null: false                    |
| price               | integer    | null: false                    |
| introduction        | string     | null: false                    |
| status_id           | integer    | null: false                    |
| delivery_charge_id  | integer    | null: false                    |
| shipping_address_id | integer    | null: false                    |
| days_to_delivery_id | integer    | null: false                    |
| category_id         | integer    | null: false                    |
| user                | references | null: false, foreign_key: true |

### Association

has_one :purchases
belongs_to :user


## purchasesテーブル

| Column | Type       | Options                        |
| -------| ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| item   | references | null: false, foreign_key: true |


### Association

belongs_to :item
belongs_to :user
has_many :shopping-address


## shopping_addresses

| Column              | Type    | Options     |
| ------------------- | ------- | ----------- |
| postal_code         | string  | null: false |
| shipping_address_id | integer | null: false |
| municipality        | string  | null: false |
| address             | string  | null: false |
| building_name       | string  | null: false |
| phone_number        | string  | null: false |

### Association

belongs_to :purchase