class Course < ApplicationRecord
  belongs_to :genre
  belongs_to :user

  scope :active, -> { where("(courses.started_at IS NULL or courses.started_at <= :date) AND (courses.ended_at IS NULL or courses.ended_at >= :date)", date: Date.today) }

  def is_active
    (started_at.nil? || started_at <= Date.today) && (ended_at.nil? || ended_at >= Date.today)
  end

  enum currency: [:NTD, :USD]

  has_many :member_courses
  has_many :members, through: :member_courses

  validates :expiration_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }

  scope :can_buy, -> (member) do
    return all unless member

    excluded_course_ids = member.member_courses.ransack(expiration_date_gt: Time.current).result.distinct.pluck(:course_id)
    active.where.not(id: excluded_course_ids)
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:can_buy]
  end
end
