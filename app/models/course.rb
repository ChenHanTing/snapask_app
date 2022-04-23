class Course < ApplicationRecord
  belongs_to :genre
  belongs_to :user

  scope :active, -> { where("(courses.started_at IS NULL or courses.started_at <= :date) AND (courses.ended_at IS NULL or courses.ended_at >= :date)", date: Date.today) }

  def is_active
    started_at <= Date.today && ended_at >= Date.today && started_at.present?
  end

  enum currency: [:NTD, :USD]
end
