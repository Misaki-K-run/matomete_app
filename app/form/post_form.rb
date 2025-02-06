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

  # ShoppingListの属性（配列として扱う）
  attribute :meat_fish, :string, default: ""
  attribute :vegetable, :string, default: ""
  attribute :other, :string, default: ""

  # バリデーション
  validates :memo, length: { maximum: 1000 }
  validates :sum, numericality: { only_integer: true }, allow_nil: true
  validates :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, length: { maximum: 2000 }
  validates :meat_fish, :vegetable, :other, length: { maximum: 2000 }

  # 配列として扱うメソッド
  def meat_fish_array
    meat_fish.present? ? meat_fish.split(",") : []
  end

  def vegetable_array
    vegetable.present? ? vegetable.split(",") : []
  end

  def other_array
    other.present? ? other.split(",") : []
  end

  # リストにアイテムを追加
  def add_meat_fish(item)
    self.meat_fish = (meat_fish_array + [item]).join(",")
  end

  def add_vegetable(item)
    self.vegetable = (vegetable_array + [item]).join(",")
  end

  def add_other(item)
    self.other = (other_array + [item]).join(",")
  end

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
        meat_fish: meat_fish.split(",").reject(&:blank?),   # 配列化
        vegetable: vegetable.split(",").reject(&:blank?),  # 配列化
        other: other.split(",").reject(&:blank?)           # 配列化
      )
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
