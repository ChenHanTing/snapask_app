class MemberCourse < ApplicationRecord
  belongs_to :member, inverse_of: :member_courses
  belongs_to :course, inverse_of: :member_courses

  enum pay_method: [:credit_card]
end
