require 'rails_helper'

def basic_pass(path)
  user_name = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{user_name}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "商品出品", type: :system do
  before do
    @item = FactoryBot.build(:item)
    @user = FactoryBot.create(:user)
  end

  context '商品出品できる時' do
    it 'ログインしたユーザーは出品できる' do
      # ログインする
      basic_pass new_user_session_path
      fill_in 'email',with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 出品ボタンが存在するか確認する
      expect(page).to have_content('出品する')
      # 出品ページに遷移する
      visit new_item_path
      # フォームの入力をする
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file("item[images][]", image_path)
      fill_in 'item-name', with: @item.product
      fill_in 'item-info', with: @item.description
      select 'メンズ', from: 'item[category_id]'
      select '新品・未使用', from: 'item[status_id]'
      select '着払い(購入者負担)', from: 'item[delivery_charge_id]'
      select '北海道', from: 'item[shipping_address_id]'
      select '1~2日で発送', from: 'item[days_to_delivery_id]'
      fill_in 'item-price', with: @item.price
      # 出品ボタンを押すとアイテムモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # トップページに出品した商品が表示されていることを確認する(画像)
      expect(page).to have_selector("img")
      # トップページに出品した商品が表示されていることを確認する(商品名)
      expect(page).to have_content(@item_product)
    end
  end

  context '商品出品できない時' do
    it 'ログインしていないと出品できない' do
      # トップページに遷移する
      basic_pass root_path
      # 出品ボタンを押すと、ログインページに遷移することを確認する
      expect(page).to have_content('出品する')
      find('a[class="purchase-btn"]').click
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '商品編集', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分の投稿した商品の編集ができる' do
      # 商品１を投稿したユーザーでログインする
      basic_pass new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品１の詳細ページに「編集」ボタンがあることを確認する
      visit item_path(@item1)
      expect(page).to have_content('商品の編集')
      # 編集ページに遷移する
      visit edit_item_path(@item1)
      # すでに投稿した商品の情報がフォームに入っていることを確認する
      expect(
        find('#item-name').value
      ).to eq(@item1.product)
      expect(
        find('#item-info').value
      ).to eq(@item1.description)
      expect(
        find('#item-category').value
      ).to eq"#{@item1.category_id}"
      expect(
        find('#item-sales-status').value
      ).to eq"#{@item1.status_id}"
      expect(
        find('#item-shipping-fee-status').value
      ).to eq"#{@item1.delivery_charge_id}"
      expect(
        find('#item-prefecture').value
      ).to eq"#{@item1.shipping_address_id}"
      expect(
        find('#item-scheduled-delivery').value
      ).to eq"#{@item1.days_to_delivery_id}"
      expect(
        find('#item-price').value
      ).to eq"#{@item1.price}"
      # 投稿内容を編集する
      image_path2 = Rails.root.join('public/images/test_image2.png')
      attach_file("item[images][]", image_path2)
      fill_in 'item-name', with: "#{@item1.product}+編集したテキスト"
      fill_in 'item-info', with: "#{@item1.description}+編集したテキスト"
      select 'レディース', from: 'item[category_id]'
      select '未使用に近い', from: 'item[status_id]'
      select '送料込み(出品者負担)', from: 'item[delivery_charge_id]'
      select '愛知県', from: 'item[shipping_address_id]'
      select '2~3日で発送', from: 'item[days_to_delivery_id]'
      fill_in 'item-price', with: "#{@item1.price+100}"
      # 編集してもItemモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      # 商品詳細ページに遷移したことを確認する
      expect(current_path).to eq(item_path(@item1))
      # 変更した内容が反映されていることを確認する(画像)
      expect(page).to have_selector("img")
      # 変更した内容が反映されていることを確認する(テキスト)
      expect(page).to have_content("#{@item1.product}+編集したテキスト")
      expect(page).to have_content("#{@item1.description}+編集したテキスト")
    end
  end
  context '商品編集ができない時' do
    it 'ログインしたユーザーは自分が投稿した商品以外は編集できない' do
      # 商品１を投稿したユーザーでログインする
      basic_pass new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品２の詳細ページに遷移する
      visit item_path(@item2)
      # 商品２の詳細ページに「編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
    end
    it 'ログインしていないと商品編集画面に遷移できない' do
      # トップページにいる
      basic_pass root_path
      # 商品１の詳細ページに遷移する
      visit item_path(@item1)
      # 商品１の詳細ページに「編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 商品２の詳細ページに遷移する
      visit root_path
      visit item_path(@item2)
      # 商品２の詳細ページに「編集」ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品削除できる時' do
    it 'ログインしたユーザーは自分の投稿した商品を削除できる' do
      # 商品１を投稿したユーザーでログインする
      basic_pass new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品１の詳細ページに「削除」ボタンがあることを確認する
      visit item_path(@item1)
      expect(page).to have_content('削除')
      # 投稿を削除するとレコードの数が１減ることを確認する
      expect{
        find('a[class="item-destroy"]').click
      }.to change { Item.count }.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページに商品1の内容が存在しないことを確認する(商品名)
      expect(page).to have_no_content("#{@item1.product}")
    end
  end
  context '商品削除できない時' do
    it 'ログインしたユーザーは自分以外の投稿された商品を削除できない' do
      # 商品1を投稿したユーザーでログインする
      basic_pass new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 商品2の詳細ページに「削除」ボタンがないことを確認する
      visit item_path(@item2)
      expect(page).to have_no_content('削除')
    end
    it 'ログインしていないと商品の「削除」ボタンがない' do
      # 商品1の詳細ページ移動する
      visit item_path(@item1)
      # 商品1の詳細ページに「削除」ボタンがないことを確認する
      expect(page).to have_no_content('削除')
      # 商品2の詳細ページに移動する
      visit item_path(@item2)
      # 商品2の詳細ページに「削除」ボタンがないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
end
RSpec.describe '商品詳細', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  it 'ログインしたユーザーは商品詳細ページに遷移して、コメント投稿欄が表示される' do
    # ログインする
    basic_pass new_user_session_path
    fill_in 'email', with: @item.user.email
    fill_in 'password', with: @item.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    # 商品詳細ページに遷移する
    visit item_path(@item)
    # 詳細ページに商品の内容が含まれている
    expect(page).to have_content("#{@item.product}")
    # コメント用フォームが存在する
    expect(page).to have_selector('textarea[id="comment_text"]')
  end
  it 'ログインしていない状態で商品詳細ページに遷移できるが、コメント投稿欄は表示されない' do
    # トップページに移動する
    basic_pass root_path
    # 商品詳細ページに遷移する
    visit item_path(@item)
    # 詳細ページに商品の内容が含まれている
    expect(page).to have_content("#{@item.product}")
    # コメント用のフォームが存在していないことを確認する
    expect(page).to have_no_selector('textarea[id="comment_text"]')
  end
end