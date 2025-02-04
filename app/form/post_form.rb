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

  # バリデーション
  validates :memo, length: { maximum: 1000 }
  validates :sum, numericality: { only_integer: true }, allow_nil: true
  validates :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, length: { maximum: 2000 }

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      post = Post.create!(memo: memo, sum: sum, user_id: user_id)
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
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
