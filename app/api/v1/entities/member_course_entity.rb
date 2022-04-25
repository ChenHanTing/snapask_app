module V1
  module Entities
    # 含付款資料
    class MemberCourseEntity < Grape::Entity
      expose :paid_at, documentation: { type: 'string', required: true, desc: "付款時間" }
      expose :pay_method, documentation: { type: 'string', required: true, desc: "付款方式" }
      expose :course, using: CourseEntity
    end
  end
end