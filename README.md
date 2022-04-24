# Snapask App

請做一個簡單的線上課程平台，該平台提供的線上課程都是有時效性，一但過了時效性，使用者就必須重新購買，以再次取用該課程內容。

#### 需要有一個後台可以讓管理者管理教育課程。

1. ☑️可以執行CRUD基本操作

2. ☑️若使用者不是管理員，則不允許操作

3. ☑️可以設定課程主題

4. ☑️可以設定課程價格，幣別

  5. ☑️可以設定課程類型

  6. ☑️可以設定課程上下架

  7. ☑️可以設定課程URL，以及描述

  8. 可以設定課程效期 1天 ~ 1個月 

#### 這個平台可以讓用戶用API購買教育課程。

  1. ☑️購買後須建立購買紀錄

  2. ☑️若課程已下架，則不能進行購買

  3. ☑️若使用者已購買過該課程，且目前還可以取用，則不允許重複購買

#### 用戶可以用API瀏覽他所有購買過的課程

  1. 回傳結果要包含課程基本資料

  2. 回傳結果要包含所有跟該課程相關的付款資料

  3. 可以用過濾方式找出特定類型的課程

  4. 可以用過濾方式找出目前還可以上的課程

#### 需求

  1. ☑️需使用 Grape & Grape entity gem

  2. ☑️code 需上 Github，並按照 Github flow。

  3. ☑️不用串金流

4. ☑️使用 rails 4 或 rails 5 ➡️Rails 5

#### 加分題

1. 使用 Rspec 撰寫測試 

2. 請 deploy 到 Heroku or AWS EC2 ➡️Heroku

## 紀錄

````sh
rails _5.2.7_ new snapaskapp
bundle add devise
rails generate devise:install

# 前台使用者 & 後台會員
rails generate devise user
rails generate devise member

# 後台使用者畫面
rails generate devise:views users

# 前台grape
bundle add grape
bundle add grape-entity
bundle add swagger_ui_engine

# 排版工具
bundle add slim-rails

# 首頁(不擋)
rails g controller pages index 
````

routes.rb

````ruby
# 會員
devise_for :users
# 首頁
root to: 'pages#index'
````

cdn boostrap & 通用模版

````erb
<!DOCTYPE html>
<html>
  <head>
    <title>Snapaskapp</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
  
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
  <nav class="navbar navbar-expand-sm navbar-dark bg-dark">
    <div class="container-fluid">
      <%= link_to "Snapask App", root_path, class: "navbar-brand" %>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="mynavbar">
        <ul class="navbar-nav me-auto">
          <% if user_signed_in? %>
            <li class="nav-item">
              <%= link_to "Users", "#!", class: "nav-link" %>
            </li>
          <% end %>
          <li class="nav-item">
            <%= link_to "Blogs", "#!", class: "nav-link" %>
          </li>
          <li class="nav-item">
            <%= link_to "Articles", "#!", class: "nav-link" %>
          </li>
        </ul>
        <ul class="navbar-nav">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle"
               href="#"
               id="navbarDropdown"
               role="button"
               data-bs-toggle="dropdown"
               aria-expanded="false">
              <%= user_signed_in? ? "HI! #{current_user.email.split("@").first}" : "Guest" %>
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
              <% if user_signed_in? %>
                <li class="nav-item">
                  <%= link_to "logout", destroy_user_session_path, method: :delete, class: "dropdown-item" %>
                </li>
              <% else %>
                <li class="nav-item">
                  <%= link_to "login", new_user_session_path, class: "dropdown-item" %>
                </li>
                <li class="nav-item">
                  <%= link_to "register", new_user_registration_path, class: "dropdown-item" %>
                </li>
              <% end %>
            </ul>
          </li>
        </ul>
        <form class="d-flex mx-lg-2">
          <input class="form-control me-2" type="text" placeholder="Search">
          <button class="btn btn-primary" type="button">Search</button>
        </form>
      </div>
    </div>
  </nav>

  <div class="container mt-4">
    <% flash.each do |type, msg| %>
      <div class="alert alert-info">
        <%= msg %>
      </div>
    <% end %>
    <%= yield %>
  </div>
  </body>
</html>
````

由於結構簡單，線上跟本地的資料庫先分開

```ruby
group :production do
  gem "pg"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end
```

scaffold CRUD + migration

````sh
# 預想的role: super_admin, admin, ordinary
rails g migration add_is_admin_to_user role:integer

# 類別 & 課程
rails generate scaffold Genre title
rails generate scaffold Course topic description currency:integer started_at:datetime ended_at:datetime genre:belongs_to url expiration_day:integer

# 會員購客(Grape用)
rails g model member_course expiration_date:datetime member:belongs_to courses.rb:belongs_to pay_method:integer paid_at:datetime
````

````txt
[WARNING] The model name 'member_courses' was recognized as a plural, using the singular 'member_course' instead. Override with --force-plural or setup custom inflection rules for this noun before running the generator.
````

## 後台畫面

#### 類別新增、編輯、列表頁

訪客以及普通權限只能看到以下畫面，且不能新增、編輯課程

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lqz83d5uj21ha0ij3z4.jpg)

super admin 可以看到的畫面如下，而admin 與 super admin的差別只有在不能調整其他使用者的權限，因此也不能進入使用者畫面

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lr0rd6cfj21ha0daaaq.jpg)

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lrineavyj21hb0knt9y.jpg)

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lrly0xayj21h70l9gn8.jpg)

### Grape

````txt
http://localhost:3000/api/v1/swagger_doc

http://localhost:3000/swagger
undefined method `before_filter' for GrapeSwaggerRails::ApplicationController:Class Did you mean? before_action
````

#### OAuth

````sh
rails generate doorkeeper:migration
rails db:migrate
````

在 `initializers/doorkeeper.rb`

````ruby
Doorkeeper.configure do
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
  end

  resource_owner_from_credentials do |routes|
    Customer.authenticate(params[:email], params[:password])
  end

  use_refresh_token

  skip_authorization do
    true
  end

  api_only

  enforce_configured_scopes
end
````

登入會員

````txt
POST /oauth/token HTTP/1.1
Host: localhost:3000
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 0481e43d-2ca2-b29b-402f-45f20dc4a0cc

{
	"email": "kd@gmail.com",
	"password": "123456",
	"grant_type": "password",
	"client_id": "YOx8-q08UK0sXSD4SVPQQL7JPO0vMoolwoSje7xP1NQ",
	"client_secret": "eDt2i-XJ5rT-OVJt_nph1wmI5DRC81MUMdOhI8s_l5k"
}
````

會員註冊

````txt
POST /api/v1/members HTTP/1.1
Host: localhost:3000
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 4c382b13-a63f-5f39-c73f-59b49a7bfe2d

{
	"email": "ke@gmail.com",
	"password": "123456"
}
````

查看會員狀態登入失敗回傳401 

````txt
GET /api/v1/members HTTP/1.1
Host: localhost:3000
Cache-Control: no-cache
Postman-Token: d8740107-072f-1d5b-260b-ef10e0d4a910
````

查看會員狀態登入成功範例

````txt
GET /api/v1/members HTTP/1.1
Host: localhost:3000
Authorization: Bearer Afa9Qx_7UsURlOl7YiSSiTLQj0k8dTeEFnkxYJxMVj8
Cache-Control: no-cache
Postman-Token: bec184b3-b213-09f7-f8f5-a940e1a464e4
````

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1loqo58iuj20uc0dqt9v.jpg)

要使得Rails 5專案看懂 `doorkeeper_token`，必須include

````ruby
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
````

#### 購買課程

課程已購買且在效期內

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lrnwg1pkj20u40fy75b.jpg)

找不到課程

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lrmwj8a0j20u40fy75b.jpg)

購買成功

![](https://tva1.sinaimg.cn/large/e6c9d24egy1h1lrog39r2j20ub0fy75d.jpg)

#### 購買記錄列表 - 搭配 ransack 使用



### 參考資料

- [A Japanese how to implement api using Grape](https://qiita.com/mktakuya/items/393d06fed4da75074667)
- doorkeeper
  - [Devise with Doorkeeper](https://rubyyagi.com/rails-api-authentication-devise-doorkeeper/)
  - [Doorkeeper Gitbook](https://doorkeeper.gitbook.io/guides/)
  - [Doorkeeper Grape INtegration - Rails 5 要人工多include helper method](https://doorkeeper.gitbook.io/guides/grape/grape)



