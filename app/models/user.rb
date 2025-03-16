class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :encrypted_password, presence: true, length: { minimum: 7 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  mount_uploader :avatar, AvatarUploader

  # 関連付け
  has_many :posts, dependent: :destroy
  has_many :ai_generates, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :favorites, dependent: :destroy
  has_many :favorite_ai_generates, through: :favorites, source: :ai_generate


  def own?(post)
    id == post.user_id
  end

  # ブックマーク
  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  # お気に入り登録
  def favorite(ai_generate)
    favorite_ai_generates << ai_generate
  end

  def unfavorite(ai_generate)
    favorite_ai_generates.destroy(ai_generate)
  end

  def favorite?(ai_generate)
    favorite_ai_generates.include?(ai_generate)
  end

  # ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "people", "budget" ]
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
