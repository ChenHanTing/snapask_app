module V1
  module Entities
    class CourseEntity < Grape::Entity
      expose :id, documentation: { type: 'integer', required: true }
      expose :topic, documentation: { type: 'string', required: true, desc: "テーマ" }
      expose :description, documentation: { type: 'string', required: true, desc: "紹介" }
      expose :genre, using: GenreEntity
      expose :currency, documentation: { type: 'string', required: true, desc: "幣別" }
    end
  end
end