module V1
  class Base < Grape::API
    version 'v1', using: :path
    mount Ping
    mount Members
    mount Courses

    add_swagger_documentation(
      api_version: "api/v1",
      hide_documentation_path: true,
      hide_format: true
    )
  end
end
