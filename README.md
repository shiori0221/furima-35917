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
| profile            | text   |                           |

### Association

has_many :items
has_many :purchases
has_many :comments

## itemsテーブル

| Column               | ype       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| product             | string     | null: false                    |
| price               | integer    | null: false                    |
| description         | text       | null: false                    |
| status_id           | integer    | null: false                    |
| delivery_charge_id  | integer    | null: false                    |
| shipping_address_id | integer    | null: false                    |
| days_to_delivery_id | integer    | null: false                    |
| category_id         | integer    | null: false                    |
| user                | references | null: false, foreign_key: true |

### Association

has_one :purchase
belongs_to :user
has_many :comments


## purchasesテーブル

| Column | Type       | Options                        |
| -------| ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| item   | references | null: false, foreign_key: true |


### Association

belongs_to :item
belongs_to :user
has_one :shopping_address


## shopping_addresses

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| postal_code         | string     | null: false                    |
| shipping_address_id | integer    | null: false                    |
| municipality        | string     | null: false                    |
| address             | string     | null: false                    |
| building_name       | string     |                                |
| phone_number        | string     | null: false                    |
| purchase            | references | null: false, foreign_key: true |

### Association

belongs_to :purchase


## comments

| Column | Type       | Options                        |
| ------ |  --------- | ------------------------------ |
| text   | text       | null: false                    |
| user   | references | null: false, foreign_key: true |
| item   | references | null: false, foreign_key: true |

### Association

belongs_to :user
belongs_to :item