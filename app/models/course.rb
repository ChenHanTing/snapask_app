class Course < ApplicationRecord
  belongs_to :genre

  enum currency: [:NTD, :USD]
end
