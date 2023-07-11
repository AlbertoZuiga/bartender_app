class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :ratings

  def recipes
    Recipe.all
  end

  validates :first_name, :last_name, :email, :password, presence: true

  enum :profile, {
    normal: 0,
    admin: 1
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
