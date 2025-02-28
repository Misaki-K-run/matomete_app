class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :encrypted_password, presence: true, length: { minimum: 7 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  # 関連付け
  has_many :posts, dependent: :destroy
  has_many :ai_generates, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post


  def own?(post)
    id == post.user_id
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  # ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "people", "budget" ]
  end
end
