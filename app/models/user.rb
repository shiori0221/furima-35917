class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  
  validates :password, :password_confirmation, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i },length: {minimum: 6 }, confirmation: true, allow_blank: true, on: :update
  with_options presence: true do
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
    validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }, length: {minimum: 6 }, confirmation: true, on: :create
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
  has_many :purchases
  has_many :comments

  def update_without_current_password(params, *options)
    params.delete(:current_password)
 
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
 
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
