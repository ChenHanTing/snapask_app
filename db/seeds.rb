# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create(email: "kd@gmail.com", password: "123456", role: :super_admin)
User.create(email: "ke@gmail.com", password: "123456", role: :admin)

g1 = Genre.find_or_create_by(title: "中文類")
g2 = Genre.find_or_create_by(title: "英文類")

Course.create(topic: "大家一起學中文", description: "學中文", genre: g1, user: u, expiration_day: 30)
Course.create(topic: "大家一起學英文", description: "學英文", genre: g2, user: u, expiration_day: 30)

Member.create(email: "kd@gmail.com", password: "123456")

Doorkeeper::Application.create!(name: "Login", redirect_uri: '')