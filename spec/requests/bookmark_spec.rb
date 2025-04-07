require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:created_post) { create(:post) }

  before do
    sign_in user
  end

  describe "POST /bookmarks" do
    it "投稿のbookmarkができる" do
      post bookmarks_path, params: { post_id: created_post.id }, headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response.body).to include("turbo-stream")
    end
  end

  describe "DELETE /bookmarks/:id" do
    it "投稿のbookmarkを解除できる" do
      bookmark = user.bookmarks.create!(post: created_post)

      delete bookmark_path(bookmark), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response.body).to include("turbo-stream")
    end
  end
end
