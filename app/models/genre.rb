class Genre < ApplicationRecord
  # sql constraint of uniqueness (沒有用): https://stackoverflow.com/questions/14622143/adding-unique-true-for-add-column-and-add-index-in-active-record
  validates :title, uniqueness: true
end
