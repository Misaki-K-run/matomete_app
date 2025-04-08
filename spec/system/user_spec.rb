require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    driven_by(:rack_test)
  end

  it '新規登録フォームから正常にユーザーを作成できる' do
    visit new_user_registration_path

    fill_in 'ユーザー名', with: 'testuser'
    fill_in 'メールアドレス', with: 'testuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード確認用', with: 'password123'

    click_button '新規登録'

    expect(page).to have_current_path(posts_path)
    expect(page).to have_text('アカウント登録が完了しました')
  end
end
