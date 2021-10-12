require 'rails_helper'


def basic_pass(path)
  user_name = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{user_name}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "コメント投稿", type: :system do
  before do
    @item = FactoryBot.create(:item)
    @comment = Faker::Lorem.sentence
  end

  it 'ログインしたユーザーは商品詳細ページでコメントを投稿できる' do
    # ログインする
    basic_pass new_user_session_path
    fill_in 'email', with: @item.user.email
    fill_in 'password', with: @item.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    # 商品詳細ページに遷移する
    visit item_path(@item)
    # フォームに情報を入力する
    fill_in 'comment_text', with: @comment
    # 送信ボタンを押すとコメントモデルのカウントが1上がることを確認する
    expect{
      find('input[value="コメントする"]').click
    }.to change { Comment.count }.by(1)
    # 詳細ページにリダイレクトされる
    expect(current_path).to eq(item_path(@item))
    # 詳細ページ上のコメント一覧に東欧したコメント内容が含まれている
    expect(page).to have_content("#{@comment}")
  end
end
