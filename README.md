# Snapask App

請做一個簡單的線上課程平台，該平台提供的線上課程都是有時效性，一但過了時效性，使用者就必須重新購買，以再次取用該課程內容。

#### 需要有一個後台可以讓管理者管理教育課程。

1. 可以執行CRUD基本操作

2. 若使用者不是管理員，則不允許操作

3. 可以設定課程主題

4. 可以設定課程價格，幣別

  5. 可以設定課程類型

  6. 可以設定課程上下架

  7. 可以設定課程URL，以及描述

  8. 可以設定課程效期 1天 ~ 1個月 

#### 這個平台可以讓用戶用API購買教育課程。

  1. 購買後須建立購買紀錄

  2. 若課程已下架，則不能進行購買

  3. 若使用者已購買過該課程，且目前還可以取用，則不允許重複購買

#### 用戶可以用API瀏覽他所有購買過的課程

  1. 回傳結果要包含課程基本資料

  2. 回傳結果要包含所有跟該課程相關的付款資料

  3. 可以用過濾方式找出特定類型的課程

  4. 可以用過濾方式找出目前還可以上的課程

#### 需求

  1. 需使用 Grape & Grape entity gem

  2. code 需上 Github，並按照 Github flow。

  3. 不用串金流

4. 使用 rails 4 或 rails 5 ➡️Rails 5

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
rails g model member_course expiration_date:datetime member:belongs_to courses:belongs_to pay_method:integer paid_at:datetime
````

````txt
[WARNING] The model name 'member_courses' was recognized as a plural, using the singular 'member_course' instead. Override with --force-plural or setup custom inflection rules for this noun before running the generator.
````

seed

````ruby
````



### 參考資料

- [女子高中生的虛度日常](https://ani.gamer.com.tw/animeVideo.php?sn=13222)



