require 'rails_helper'

RSpec.describe PurchaseShoppingAddress, type: :model do
  describe '購入情報の保存' do
    before do
      user = FactoryBot.create(:user)
      item = FactoryBot.create(:item)
      @purchase_shopping_address = FactoryBot.build(:purchase_shopping_address, user_id: user.id, item_id: item.id)
      sleep 0.1
    end

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@purchase_shopping_address).to be_valid
      end
      it 'building_nameは空でも保存できること' do
        @purchase_shopping_address.building_name = ''
        expect(@purchase_shopping_address).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'tokenが空だと保存できないこと' do
        @purchase_shopping_address.token = nil
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Token can't be blank")
      end
      it 'postal_codeが空だと保存できないこと' do
        @purchase_shopping_address.postal_code = ''
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Postal code can't be blank")
      end
      it 'postal_codeが半角のハイフンを含んだ正しい形式でないと保存できないこと' do
        @purchase_shopping_address.postal_code = '1111111'
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include('Postal code is invalid. Include hyphen(-)')
      end
      it 'shipping_address_idが空だと保存できないこと' do
        @purchase_shopping_address.shipping_address_id = ''
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Shipping address can't be blank")
      end
      it 'shipping_address_idが1だと保存できないこと' do
        @purchase_shopping_address.shipping_address_id = '1'
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Shipping address can't be blank")
      end
      it 'municipalityが空だと保存できないこと' do
        @purchase_shopping_address.municipality = ''
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Municipality can't be blank")
      end
      it 'addressが空だと保存できないこと' do
        @purchase_shopping_address.address = ''
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Address can't be blank")
      end
      it 'phone_numberが空だと保存できないこと' do
        @purchase_shopping_address.phone_number = ''
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが9文字以下では保存できないこと' do
        @purchase_shopping_address.phone_number = '111111111'
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include('Phone number is too short (minimum is 10 characters)')
      end
      it 'phone_numberが12文字以上では保存できないこと' do
        @purchase_shopping_address.phone_number = '111111111111'
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include('Phone number is too long (maximum is 11 characters)')
      end
      it 'userが紐付いていないと保存できないこと' do
        @purchase_shopping_address.user_id = nil
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("User can't be blank")
      end
      it 'itemが紐付いていないと保存できないこと' do
        @purchase_shopping_address.item_id = nil
        @purchase_shopping_address.valid?
        expect(@purchase_shopping_address.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
