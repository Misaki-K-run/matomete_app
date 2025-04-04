require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  describe 'バリデーションのテスト' do
    let(:shopping_list) { build(:shopping_list) }

    context '有効なShoppingList' do
      it 'categoryとnameが適切な場合、有効であること' do
        expect(shopping_list).to be_valid
      end
    end

    context '無効なShoppingList' do
      it 'nameが100文字を超える場合、無効であること' do
        shopping_list.name = 'a' * 101
        expect(shopping_list).to be_invalid
        expect(shopping_list.errors[:name]).to include('は100文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:post) }
  end
end
