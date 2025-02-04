class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Postの属性
  attribute :memo, :string
  attribute :sum, :integer
  attribute :user_id, :integer

  # Menuの属性
  attribute :monday, :string
  attribute :tuesday, :string
  attribute :wednesday, :string
  attribute :thursday, :string
  attribute :friday, :string
  attribute :saturday, :string
  attribute :sunday, :string

    # ShoppingListの属性
    attribute :meat_fish, :string
    attribute :vegetable, :string
    attribute :other, :string

  # バリデーション
  validates :memo, length: { maximum: 1000 }
  validates :sum, numericality: { only_integer: true }, allow_nil: true
  validates :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, length: { maximum: 2000 }
  validates :meat_fish, :vegetable, :other, length: { maximum: 2000 }

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      # Postの作成
      post = Post.create!(memo: memo, sum: sum, user_id: user_id)

      # Menuの作成
      Menu.create!(
        post_id: post.id,
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday
      )

      # ShoppingListの作成
      ShoppingList.create!(
        post_id: post.id,
        meat_fish: meat_fish,
        vegetable: vegetable,
        other: other
      )
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
