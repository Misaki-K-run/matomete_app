require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'バリデーションのテスト' do
    let(:menu) { build(:menu) }

    context '有効なMenu' do
      it '各曜日の属性が2000文字以内であれば、有効であること' do
        expect(menu).to be_valid
      end
    end

    context '無効なMenu' do
      it 'mondayが2000文字を超える場合、無効であること' do
        menu.monday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:monday]).to include('は2000文字以内で入力してください')
      end

      it 'tuesdayが2000文字を超える場合、無効であること' do
        menu.tuesday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:tuesday]).to include('は2000文字以内で入力してください')
      end

      it 'wednesdayが2000文字を超える場合、無効であること' do
        menu.wednesday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:wednesday]).to include('は2000文字以内で入力してください')
      end

      it 'thursdayが2000文字を超える場合、無効であること' do
        menu.thursday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:thursday]).to include('は2000文字以内で入力してください')
      end

      it 'fridayが2000文字を超える場合、無効であること' do
        menu.friday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:friday]).to include('は2000文字以内で入力してください')
      end

      it 'saturdayが2000文字を超える場合、無効であること' do
        menu.saturday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:saturday]).to include('は2000文字以内で入力してください')
      end

      it 'sundayが2000文字を超える場合、無効であること' do
        menu.sunday = 'a' * 2001
        expect(menu).to be_invalid
        expect(menu.errors[:sunday]).to include('は2000文字以内で入力してください')
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:post) }
  end
end
