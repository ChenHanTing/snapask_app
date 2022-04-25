module V1
  class Courses < Grape::API
    resources :courses do
      desc "課程列表"
      params do
        optional :can_buy, type: Boolean
        optional :genre_id, type: Integer
      end
      get do
        V1::Entities::CourseEntity.represent(
          Course.ransack(
            can_buy: params[:can_buy].presence && current_member,
            genre_id_eq: params[:genre_id]
          ).result
        )
      end

      desc "所有種類"
      get "/genre" do
        V1::Entities::GenreEntity.represent(Genre.all)
      end

      desc "購買記錄"
      before { authenticate_member! }
      get "/record" do
        V1::Entities::MemberCourseEntity.represent(current_member.member_courses)
      end

      desc "購買課程動作 - 簡化付款流程，假設在購買時同時付款且付款行為不會失敗"
      params do
        requires :course_id, type: Integer
      end
      before { authenticate_member! }
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