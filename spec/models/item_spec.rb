require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#create' do
    before do
      @item = FactoryBot.build(:item)
    end

    describe '商品出品機能' do
      context '商品出品できるとき' do
        it 'product,price,description,status_id,delivery_charge_id,shipping_address_id,days_to_delivery_id,category_id,imageが存在すれば出品できる' do
          expect(@item).to be_valid
        end
      end
      context '商品出品できないとき' do
        it 'productが空では出品できない' do
          @item.product = ''
          @item.valid?
          expect(@item.errors[:product]).to include(I18n.t('errors.messages.blank'))
        end
        it 'priceが空では出品できない' do
          @item.price = ''
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.blank'))
        end
        it 'descriptionが空では出品できない' do
          @item.description = ''
          @item.valid?
          expect(@item.errors[:description]).to include(I18n.t('errors.messages.blank'))
        end
        it 'status_idが空では出品できない' do
          @item.status_id = ''
          @item.valid?
          expect(@item.errors[:status_id]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'delivery_charge_idが空では出品できない' do
          @item.delivery_charge_id = ''
          @item.valid?
          expect(@item.errors[:delivery_charge_id]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'shipping_address_idが空では出品できない' do
          @item.shipping_address_id = ''
          @item.valid?
          expect(@item.errors[:shipping_address_id]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'days_to_delivery_idが空では出品できない' do
          @item.days_to_delivery_id = ''
          @item.valid?
          expect(@item.errors[:days_to_delivery_id]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'category_idが空では出品できない' do
          @item.category_id = ''
          @item.valid?
          expect(@item.errors[:category_id]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'imageが空では出品できない' do
          @item.image = nil
          @item.valid?
          expect(@item.errors[:image]).to include(I18n.t('errors.messages.blank'))
        end
        it 'status_idの選択が１だと登録できない' do
          @item.status_id = '1'
          @item.valid?
          expect(@item.errors[:status_id]).to include(I18n.t('errors.messages.other_than', count: 1))
        end
        it 'deliveery_charge_idの選択が１だと登録できない' do
          @item.delivery_charge_id = '1'
          @item.valid?
          expect(@item.errors[:delivery_charge_id]).to include(I18n.t('errors.messages.other_than', count: 1))
        end
        it 'shipping_address_idの選択が１だと登録できない' do
          @item.shipping_address_id = '1'
          @item.valid?
          expect(@item.errors[:shipping_address_id]).to include(I18n.t('errors.messages.other_than', count: 1))
        end
        it 'days_to_delivery_idの選択が１だと登録できない' do
          @item.days_to_delivery_id = '1'
          @item.valid?
          expect(@item.errors[:days_to_delivery_id]).to include(I18n.t('errors.messages.other_than', count: 1))
        end
        it 'category_idの選択が１だと登録できない' do
          @item.category_id = '1'
          @item.valid?
          expect(@item.errors[:category_id]).to include(I18n.t('errors.messages.other_than', count: 1))
        end
        it 'priceが300円より低いと出品できない' do
          @item.price = '200'
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.greater_than_or_equal_to', count: 300))
        end
        it 'priceが9999999円より高いと出品できない' do
          @item.price = '10000000'
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.less_than_or_equal_to', count: 9_999_999))
        end
        it 'priceは半角英字だと登録できない' do
          @item.price = 'aaa'
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'priceが半角英数字混合だと登録できない' do
          @item.price = '11aa'
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'priceが全角数字だと登録できない' do
          @item.price = '３００'
          @item.valid?
          expect(@item.errors[:price]).to include(I18n.t('errors.messages.not_a_number'))
        end
        it 'ユーザーが紐付いていなければ出品できない' do
          @item.user = nil
          @item.valid?
          expect(@item.errors[:user]).to include(I18n.t('errors.messages.required'))
        end
      end
    end
  end
end
