module V1
  module Entities
    class CourseEntity < Grape::Entity
      expose :id, documentation: { type: 'integer', required: true }
      expose :topic, documentation: { type: 'string', required: true }
    end
  end
end