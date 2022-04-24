module V1
  class Courses < Grape::API
    before { authenticate_member! }

    resources :courses do
      desc "購買記錄"
      get do

      end

      desc "購買課程動作 - 簡化付款流程，假設在購買時同時付款且付款行為不會失敗"
      params do
        requires :course_id, type: Integer
      end
      post do
        course = Course.find_by(id: params[:course_id])
        if course
          # 已購買課程且還在效期內...
          if current_member.member_courses.where(course_id: course.id).pluck(:expiration_date).any? { |d| d >= Time.current }
            status 400

            return { success: false, message: "已購買課程" }
          end
          # 不在檔期內...
          unless course.is_active
            status 400

            return { success: false, message: "現在不是購買課程時間" }
          end

          current_member.member_courses.create!(course: course,
                                                pay_method: :credit_card,
                                                paid_at: Time.current, expiration_date: (course.expiration_day || 30).days.from_now)

          {
            success: true,
            member: current_member.email,
            id: course&.id
          }
        else
          status 404

          { success: false, message: "找不到課程" }
        end
      end
    end
  end
end