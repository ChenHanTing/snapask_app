class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :topic
      t.string :description
      t.integer :currency
      t.datetime :started_at
      t.datetime :ended_at
      t.belongs_to :genre, foreign_key: true
      t.string :url
      t.integer :expiration_day

      t.timestamps
    end
  end
end
