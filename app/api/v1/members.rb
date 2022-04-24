module V1
  class Members < Grape::API
    before do
      authenticate_member!
    end

    resources :members do
      desc "auth ping"
      get do
        { member: current_member&.email }
      end

      desc 'member register'
      params do
        requires :password, type: String
        requires :email, type: String
      end
      post do
        member = Member.create!(params)
        if member.errors.count == 0
          { success: true }
        else
          member.destroy
          { success: false, message: member.errors.full_messages }
        end
      end
    end
  end
end