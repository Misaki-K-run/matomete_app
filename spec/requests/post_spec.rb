require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:user) { create(:user, password: 'password') }
  let!(:post) { create(:post, user: user) }

  before do
    sign_in user
  end

  describe 'GET /posts 投稿一覧を取得できるか' do
    it '投稿一覧を取得できること' do
      get posts_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post.sum.to_s)
    end
  end

  describe 'GET /posts/:id 投稿を編集できるか' do
    it '既存の投稿を編集できること' do
      get edit_post_path(post)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post.memo)
    end
  end

  describe 'DELETE /posts/:id 投稿を削除できるか' do
    it '投稿を削除できること' do
      delete post_path(post)

      expect(response).to redirect_to(posts_path)
      follow_redirect!
      expect(response.body).not_to include(post.memo)
    end
  end
end

RSpec.describe 'Posts', type: :request do
  let!(:user) { create(:user, password: 'password') }
  let!(:created_post) { create(:post, :with_menu, user: user) }

  before do
    sign_in user
  end

  describe 'POST /posts 投稿を作成できるか' do
    it '新しい投稿を作成できること' do
      post posts_path, params: { post_form: { memo: 'New Post', sum: 5000 } }

      expect(response).to redirect_to(posts_path)
      follow_redirect!
      expect(response.body).to include("投稿できました")
    end
  end

  describe 'PATCH /posts/:id 投稿を更新できるか' do
    it '投稿を編集して更新できること' do
      patch post_path(created_post), params: {
        post_form: {
          memo: 'Updated Post',
          sum: 6000,
          monday: 'カレー',
          tuesday: 'うどん',
          shopping_list_items: [{ name: '玉ねぎ', category: 'vegetable' }]
        }
      }

      expect(response).to redirect_to(posts_path)
      follow_redirect!
      expect(response.body).to include("更新できました")
    end
  end
end
