require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'nickname,email,password,password_confirmation,lastname,firstname,lastname_kana,firstname_kana,birthdayが存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors[:nickname]).to include(I18n.t('errors.messages.blank'))
      end
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors[:email]).to include(I18n.t('errors.messages.blank'))
      end
      it 'emailで「＠」がない場合は登録できない' do
        @user.email = 'sample.com'
        @user.valid?
        expect(@user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.blank'))
      end
      it 'passwordが５文字以下であれば登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.too_short', count: 6))
      end
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123567'
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'passwordが存在してもpassword_confirmationがない場合は登録できない' do
        @user.password = '123456'
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'passwordが英語のみでは登録できない' do
        @user.password = 'aaaaaa'
        @user.password_confirmation = 'aaaaaa'
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'passwordが数字のみでは登録できない' do
        @user.password = '111111'
        @user.password_confirmation = '111111'
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'passwordが全角では登録できない' do
        @user.password = 'ＢＢＢ１１１'
        @user.password_confirmation = 'ＢＢＢ１１１'
        @user.valid?
        expect(@user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
      end
      it '重複したemailが存在する場合登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors[:email]).to include(I18n.t('errors.messages.taken'))
      end
      it 'lastnameが空では登録できない' do
        @user.lastname = ''
        @user.valid?
        expect(@user.errors[:lastname]).to include(I18n.t('errors.messages.blank'))
      end
      it 'firstnameが空では登録できない' do
        @user.firstname = ''
        @user.valid?
        expect(@user.errors[:firstname]).to include(I18n.t('errors.messages.blank'))
      end
      it 'lastname_kanaが空では登録できない' do
        @user.lastname_kana = ''
        @user.valid?
        expect(@user.errors[:lastname_kana]).to include(I18n.t('errors.messages.blank'))
      end
      it 'firstname_kanaが空では登録できない' do
        @user.firstname_kana = ''
        @user.valid?
        expect(@user.errors[:firstname_kana]).to include(I18n.t('errors.messages.blank'))
      end
      it 'birthdayが空では登録できない' do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors[:birthday]).to include(I18n.t('errors.messages.blank'))
      end
      it 'lastnameが全角入力でなければ登録できない' do
        @user.lastname = 'ｱｲｳｴｵ'
        @user.valid?
        expect(@user.errors[:lastname]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'firstnameが全角入力でなければ登録できない' do
        @user.firstname = 'ｱｲｳｴｵ'
        @user.valid?
        expect(@user.errors[:firstname]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'lastname_kanaが全角カタカナでなければ登録できない' do
        @user.lastname_kana = 'あいうえお'
        @user.valid?
        expect(@user.errors[:lastname_kana]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'firstname_kanaが全角カタカナでなければ登録できない' do
        @user.firstname_kana = 'あいうえお'
        @user.valid?
        expect(@user.errors[:firstname_kana]).to include(I18n.t('errors.messages.invalid'))
      end
    end
  end
end
