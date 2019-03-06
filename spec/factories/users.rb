FactoryBot.define do

  # factoryメソッドを利用して、:userという名前のUserクラスのファクトリを定義する。
  # クラスを、:userという名前から自動で類推してくれる

  # ファクトリ名とクラス名が異なる場合には、:classオプションでクラスを指定する。
  # factory :admin_user, class: User do
  factory :user do
    name {'テストユーザー'}
    email {'test1@example.com'}
    password {'password'}
  end
end