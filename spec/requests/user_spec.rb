require 'rails_helper'

RSpec.describe 'Users', type: :request do
  it "allows a user to sign up" do
    post user_registration_path, params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'Test User' } }
    expect(response).to redirect_to(posts_path)
    follow_redirect!
    expect(response.body).to include("アカウント登録が完了しました。")
  end


  describe 'POST /login ログインできる' do
    it 'ログインできること' do
      user = FactoryBot.create(:user, password: 'password')
      post user_session_path, params: { user: { email: user.email, password: 'password' } }

      expect(response).to have_http_status(:see_other)
      follow_redirect!
      expect(response.body).to include("ログインしました")
    end
  end

  describe 'DELETE /logout ログアウトできる' do
    it 'ログアウトできること' do
      user = FactoryBot.create(:user, password: 'password')
      sign_in user
      delete destroy_user_session_path

      expect(response).to have_http_status(:see_other)
      follow_redirect!
      expect(response.body).to include("ログアウトしました")
    end
  end
end
