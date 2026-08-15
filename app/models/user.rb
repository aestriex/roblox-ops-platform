class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :omniauthable, omniauth_providers: [:roblox]

  has_one :personnel_person, class_name: "Personnel::Person", dependent: :nullify
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :posting_applications, dependent: :destroy

  def can?(permission_key)
    roles.joins(:permissions).where(permissions: { key: permission_key }).exists?
  end

  def display_avatar_url
    avatar_url.presence || "https://api.dicebear.com/9.x/initials/svg?seed=#{email}"
  end

  def display_name
    username.presence || email
  end
end
