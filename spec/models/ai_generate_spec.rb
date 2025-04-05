require 'rails_helper'

RSpec.describe AiGenerate, type: :model do
  describe 'バリデーションのテスト' do
    let(:ai_generate) { build(:ai_generate) }

    context '有効なAiGenerate' do
      it '全ての属性が正しい場合、有効であること' do
        expect(ai_generate).to be_valid
      end
    end

    context '無効なAiGenerate' do
      it 'budget_requestが空だと無効であること' do
        ai_generate.budget_request = nil
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:budget_request]).to include("を入力してください")
      end

      it 'people_requestが空だと無効であること' do
        ai_generate.people_request = nil
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:people_request]).to include("を入力してください")
      end

      it 'menu_responseが空だと無効であること' do
        ai_generate.menu_response = nil
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:menu_response]).to include("を入力してください")
      end

      it 'shopping_list_responseが空だと無効であること' do
        ai_generate.shopping_list_response = nil
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:shopping_list_response]).to include("を入力してください")
      end

      it 'sum_responseが空だと無効であること' do
        ai_generate.sum_response = nil
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:sum_response]).to include("を入力してください")
      end

      it 'special_requestが100文字を超えると無効であること' do
        ai_generate.special_request = 'a' * 101
        expect(ai_generate).to be_invalid
        expect(ai_generate.errors[:special_request]).to include('は100文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should have_one(:favorite).dependent(:destroy) }
  end
end
