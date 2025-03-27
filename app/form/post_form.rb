class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Postの属性
  attribute :memo, :string
  attribute :sum, :integer
  attribute :user_id, :string

  # Menuの属性
  attribute :monday, :string
  attribute :tuesday, :string
  attribute :wednesday, :string
  attribute :thursday, :string
  attribute :friday, :string
  attribute :saturday, :string
  attribute :sunday, :string

  # ショッピングリストのアイテム
  attr_accessor :shopping_list_items

  # バリデーション
  validates :memo, length: { maximum: 1000 }
  validates :sum, numericality: { only_integer: true }, allow_nil: true
  validates :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, length: { maximum: 2000 }

  # 初期化
  def initialize(attributes = {})
    super(attributes)
    @shopping_list_items ||= []
  end

  # Post、Menu、ShoppingListを保存するメソッド
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      # Postの作成
      @post = Post.create!(memo: memo, sum: sum, user_id: user_id)

      # Menuの作成
      menu = Menu.create!(
        post_id: @post.id,
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday
      )
      # ShoppingListの作成
      shopping_list_items.each do |item|
        ShoppingList.create!(
          post_id: @post.id,
          name: item[:name],
          category: item[:category]
        )
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update(post)
    return false unless valid?

    ActiveRecord::Base.transaction do
      # Postの更新
      post.update!(memo: memo, sum: sum)

      # Menuの更新
      menu = post.menu
      menu.update!(
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday
      )

    # ShoppingListの更新
    existing_items = post.shopping_lists.index_by { |item| [ item.name, item.category ] }

    # 新しく送信されたアイテムの処理
    new_items = shopping_list_items.map { |item| [ item[:name], item[:category] ] }

    # 追加・更新
    shopping_list_items.each do |item|
      if existing_items.key?([ item[:name], item[:category] ])
        # 既存アイテムは更新（今回は特に変更することはないのでスキップ可）
        existing_items.delete([ item[:name], item[:category] ])
      else
        # 新規アイテムは作成
        post.shopping_lists.create!(name: item[:name], category: item[:category])
      end
    end
    puts "削除前: #{post.shopping_lists.pluck(:id, :name)}"
    # 削除されたアイテムを削除
    items_to_delete = existing_items.keys - new_items
    items_to_delete.each do |key|
      existing_items[key].destroy!
    end
    puts "削除後: #{ShoppingList.where(post_id: post.id).pluck(:id, :name)}"
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
