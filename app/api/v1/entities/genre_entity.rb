module V1
  module Entities
    class GenreEntity < Grape::Entity
      expose :id, documentation: { type: 'integer', required: true }
      expose :title, documentation: { type: 'string', required: true, desc: "類別名" }
    end
  end
end