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
