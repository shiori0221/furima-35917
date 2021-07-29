class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, :password_confirmation, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }
  with_options presence: true do
    validates :nickname
    validates :birthday
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/ } do
      validates :lastname
      validates :firstname
    end
    with_options format: { with: /\A[ァ-ヶー－]+\z/ } do
      validates :lastname_kana
      validates :firstname_kana
    end
  end

  has_many :items
end
