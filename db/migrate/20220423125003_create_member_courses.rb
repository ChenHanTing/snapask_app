class CreateMemberCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :member_courses do |t|
      t.datetime :expiration_date
      t.belongs_to :member, foreign_key: true
      t.belongs_to :course, foreign_key: true
      t.integer :pay_method
      t.datetime :paid_at

      t.timestamps
    end
  end
end
