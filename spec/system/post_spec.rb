require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    login_as(user)
    visit new_post_path
  end

  it '投稿を作成できるか' do
    fill_in 'post_form[memo]', with: 'テストメモ'
    fill_in 'post_form[sum]', with: 1000
    fill_in 'post_form[monday]', with: '月曜日のメニュー'
    fill_in 'post_form[tuesday]', with: '火曜日のメニュー'

    click_button '投稿'


    expect(page).to have_current_path(posts_path)
    expect(page).to have_text('投稿できました')

    expect(Post.last.sum).to eq 1000
  end

  it '投稿を編集できるか' do
    post = create(:post, user: user, memo: '元のメモ', sum: 500)
    menu = create(:menu, post: post)
    visit edit_post_path(post)

    fill_in 'post_form[memo]', with: '編集されたメモ'
    fill_in 'post_form[sum]', with: 2000

    click_button '更新'

    expect(page).to have_current_path(posts_path)
    expect(page).to have_text('更新できました')
  end
end
