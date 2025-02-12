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

  def own?(post)
    id == post.user_id
  end
end
