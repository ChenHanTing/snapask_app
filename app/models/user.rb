class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:super_admin, :admin, :ordinary]

  def can_edit?
    admin? || super_admin?
  end

  has_many :courses
end
