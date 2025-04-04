require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーションのテスト' do
    let(:favorite) { build(:favorite) }

    context '有効なFavorite' do
      it 'user_idとai_generate_idの組み合わせがユニークであれば有効であること' do
        expect(favorite).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should belong_to(:ai_generate) }
  end
end
