class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password,:password_confirmation,format: {with: /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i}
  with_options presence: true do
    validates :nickname
    validates :lastname,       format: {with: /\A[ぁ-んァ-ン一-龥]/}
    validates :firstname,      format: {with: /\A[ぁ-んァ-ン一-龥]/}
    validates :lastname_kana,  format: {with: /\A[ァ-ヶー－]+\z/}
    validates :firstname_kana, format: {with: /\A[ァ-ヶー－]+\z/}
    validates :birthday
  end
end
