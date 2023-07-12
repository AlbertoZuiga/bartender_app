class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :ingredients
  has_many :ratings

  def favorite_recipes
    Recipe.where(id: Rating.where(user: self, favorite: true).pluck(:recipe_id))
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
