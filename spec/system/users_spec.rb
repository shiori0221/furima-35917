require 'rails_helper'

def basic_pass(path)
  user_name = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{user_name}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザーが新規登録できる時' do
    it '正しい情報を入力すればユーザー新規登録ができて、トップページに移動する' do
      # トップページに移動する
      basic_pass root_path
      # トップページに新規登録ボタンが存在することを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      fill_in 'last-name', with: @user.lastname
      fill_in 'first-name', with: @user.firstname
      fill_in 'last-name-kana', with: @user.lastname_kana
      fill_in 'first-name-kana', with: @user.firstname_kana
      select '1930', from: 'user[birthday(1i)]'
      select '1', from: 'user[birthday(2i)]'
      select '1', from: 'user[birthday(3i)]'
      # 会員登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{find('input[name="commit"]').click}.to change { User.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
      # 新規登録ボタンやログインボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録できない時' do
    it '誤った情報ではユーザー新規登録ができず、新規登録ページに戻ってくる' do
      # トップページに移動する
      basic_pass root_path
      # トップページに新規登録ボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'nickname', with: ''
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      fill_in 'password-confirmation', with: ''
      fill_in 'last-name', with: ''
      fill_in 'first-name', with: ''
      fill_in 'last-name-kana', with: ''
      fill_in 'first-name-kana', with: ''
      select '--', from: 'user[birthday(1i)]'
      select '--', from: 'user[birthday(2i)]'
      select '--', from: 'user[birthday(3i)]'
      # 会員登録ボタンを押しても、ユーザーモデルのカウントは上がらないことを確認する
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      # 新規登録ページに戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe "ログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができる時' do
    it '保存されているユーザー情報と合致すればログインができる' do
      # トップページに移動する
      basic_pass root_path
      # トップページにログインボタンが存在することを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'email',with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移したことを確認する
      expect(current_path).to eq (root_path)
      # ログアウトボタンが存在することを確認する
      expect(page).to have_content('ログアウト')
      # 新規登録ボタンやログインボタンが表示されてされていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログインできない時' do
    it '保存されているユーザー情報と一致しないとログインできない' do
      # トップページに移動する
      basic_pass root_path
      # トップページにログインボタンが存在することを確認する
      expect(page).to have_content('ログイン')
      # ログインページに遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'email', with: ''
      fill_in 'password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに戻ることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
