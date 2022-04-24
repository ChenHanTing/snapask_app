class Course < ApplicationRecord
  belongs_to :genre
  belongs_to :user

  scope :active, -> { where("(courses.rb.started_at IS NULL or courses.rb.started_at <= :date) AND (courses.rb.ended_at IS NULL or courses.rb.ended_at >= :date)", date: Date.today) }

  def is_active
    (started_at.nil? || started_at <= Date.today) && (ended_at.nil? || ended_at >= Date.today)
  end

  enum currency: [:NTD, :USD]

  has_many :member_courses
  has_many :members, through: :member_courses
end
