require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'バリデーションのテスト' do
    let(:post) { build(:post) }

    context '有効なPost' do
      it '全ての属性が正しい場合、有効であること' do
        expect(post).to be_valid
      end
    end

    context '無効なPost' do
      it 'メモの長さが1000文字を超えると無効であること' do
        post.memo = 'a' * 1001
        expect(post).to be_invalid
        expect(post.errors[:memo]).to include('は1000文字以内で入力してください')
      end

      it '合計金額(sum)が100000を超えると無効であること' do
        post.sum = 1000001
        expect(post).to be_invalid
        expect(post.errors[:sum]).to include('は100000以下の値にしてください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should have_one(:menu).dependent(:destroy) }
    it { should have_many(:shopping_lists).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
  end

  describe 'dependent: :destroy の挙動' do
    let!(:post) { create(:post) }
    let!(:menu) { create(:menu, post: post) }
    let!(:shopping_list) { create(:shopping_list, post: post) }
    let!(:bookmark) { create(:bookmark, post: post) }

    it 'Postを削除すると関連するMenu, ShoppingList, Bookmarkも削除されること' do
      expect { post.destroy }.to change { Menu.count }.by(-1)
                            .and change { ShoppingList.count }.by(-1)
                            .and change { Bookmark.count }.by(-1)
    end
  end
end
