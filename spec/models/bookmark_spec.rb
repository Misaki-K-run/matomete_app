require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
