require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }

    context '有効なユーザー' do
      it '全ての属性が正しい場合、有効であること' do
        expect(user).to be_valid
      end
    end

    context '無効なユーザー' do
      it '名前がないと無効であること' do
        user.name = nil
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it 'メールアドレスがないと無効であること' do
        user.email = nil
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("を入力してください")
      end

      it 'パスワードがないと無効であること' do
        user.password = nil
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("を入力してください")
      end

      it '重複するメールアドレスは無効であること' do
        create(:user, email: user.email)
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("はすでに存在します")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:ai_generates).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmark_posts).through(:bookmarks).source(:post) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_ai_generates).through(:favorites).source(:ai_generate) }
  end
end
