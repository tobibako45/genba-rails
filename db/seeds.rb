# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザーを追加
# User.create!(
#   name: 'admin',
#   email: 'admin@example.com',
#   admin: true,
#   password: 'password',
#   password_confirmation: 'password'
# )


# find_or_create_by!
# admin@example.comというメールアドレスが存在するかどうか調べて、
# 存在しない場合だけUserレコードをを登録する。
# 存在する場合は、そのレコードを返す。
User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.name = 'admin'
    user.admin = true
    user.password = 'password'
    user.password_confirmation = 'password'
end