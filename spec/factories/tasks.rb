FactoryBot.define do
  factory :task do
    name {'テストを書く'}
    description {'RSpec & Capybara & FactoryBotを準備する'}

    # factories/users.rb定義した:userという名前のFactoryを、
    # Taskモデルに定義されたuserという名前の関連を生成するのに利用する という意味。
    # 名前の自動類推を活かして簡潔に記述できるようになってる。
    user

    # 関連名とファクトリ名が異なる場合はuserの代わりにこう書く。
    # association :user, factory: :admin_user
  end
end