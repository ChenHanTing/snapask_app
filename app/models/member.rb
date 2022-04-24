class Member < ApplicationRecord
  has_many :member_courses
  has_many :courses, through: :member_courses

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.authenticate(email, password)
    member = find_for_authentication(email: email)
    member&.valid_password?(password) ? member : nil
  end
end
