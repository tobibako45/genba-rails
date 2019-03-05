class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    # adminカラムを追加。NOT NULL、booleanでデフォルトはfalse
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
