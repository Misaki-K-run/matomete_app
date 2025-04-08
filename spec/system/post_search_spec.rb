RSpec.describe '投稿の検索', type: :system do
  before do
    driven_by(:rack_test)

    @user1 = User.create!(name: 'Alice', email: 'alice@example.com', password: 'password123', password_confirmation: 'password123', budget: 10000, people: 2)
    @user2 = User.create!(name: 'Bob', email: 'bob@example.com', password: 'password123', password_confirmation: 'password123', budget: 20000, people: 4)
    @user3 = User.create!(name: 'Charlie', email: 'charlie@example.com', password: 'password123', password_confirmation: 'password123', budget: 30000, people: 3)

    @post1 = Post.create!(memo: 'Post 1', sum: 1000, user: @user1)
    @post2 = Post.create!(memo: 'Post 2', sum: 2000, user: @user2)
    @post3 = Post.create!(memo: 'Post 3', sum: 3000, user: @user3)
  end

  it 'ユーザーの予算で投稿を絞り込むことができる' do
    visit posts_path

    select '〜10,000円', from: 'q_user_budget_lteq'
    find('button[type="submit"]').click

    expect(page).to have_text("1000")
    expect(page).not_to have_text("2000")
    expect(page).not_to have_text("3000")
  end

  it 'ユーザーの人数で投稿を絞り込むことができる' do
    visit posts_path

    fill_in 'q_user_people_eq', with: '2'
    find('button[type="submit"]').click

    expect(page).to have_text('1000')
    expect(page).not_to have_text('2000')
    expect(page).not_to have_text('3000')
  end

  it '予算と人数で両方の条件で絞り込むことができる' do
    visit posts_path

    select '〜20,000円', from: 'q_user_budget_lteq'
    fill_in 'q_user_people_eq', with: '4'
    find('button[type="submit"]').click

    expect(page).not_to have_text("1000")
    expect(page).to have_text("2000")
    expect(page).not_to have_text('3000')
  end

  it '検索結果が無い場合、該当する投稿が表示されない' do
    visit posts_path

    select '〜5,000円', from: 'q_user_budget_lteq'
    fill_in 'q_user_people_eq', with: '5'
    find('button[type="submit"]').click

    expect(page).to have_text('投稿が見つかりません')
  end
end
