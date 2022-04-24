require 'doorkeeper/grape/helpers'

class ApiRoot < Grape::API
  PREFIX = '/api'.freeze
  format :json
  content_type :json, "application/json"
  default_error_status 400

  rescue_from :all, backtrace: true
  helpers Doorkeeper::Grape::Helpers

  helpers do
    # 參考: https://nicedoc.io/ruby-grape/grape

    def authenticate_member!
      error!('401 Unauthorized', 401) unless current_member
    end

    # Find the user that owns the access token
    def current_member
      Member.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end

  mount V1::Base
end

